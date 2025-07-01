# Word2PDF WPF GUI Application

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Windows.Forms

$logFile = "C:/Users/lowryb/OneDrive/Documents/Scripts/Word2PDF.log"

function Log-Message {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - $message"
    Add-Content -Path $logFile -Value $logEntry
    
    # Also update the log text box in the UI
    $script:logTextBox.Dispatcher.Invoke([action]{
        $script:logTextBox.AppendText("$logEntry`r`n")
        $script:logTextBox.ScrollToEnd()
    })
}

# Function to handle Word application cleanup
function Cleanup-WordApplication {
    param (
        [Parameter(Mandatory = $true)]
        [System.Object]$WordApp
    )

    try {
        # Check if the Word application object is valid
        if ($WordApp -and $WordApp.GetType().FullName -eq "Microsoft.Office.Interop.Word.ApplicationClass") {
            # Close all documents
            if ($WordApp.Documents) {
                foreach ($Document in $WordApp.Documents) {
                    try {
                        $Document.Close([ref]$false) # Don't save changes
                        [System.Runtime.InteropServices.Marshal]::ReleaseComObject($Document)
                    }
                    catch {
                        Log-Message "Error closing document: $($_.Exception.Message)"
                    }
                    finally {
                        # Ensure COM object is released
                        [System.Runtime.InteropServices.Marshal]::ReleaseComObject($Document)
                    }
                }
            }

            # Quit the Word application
            $WordApp.Quit()
            Log-Message "Word application closed."
        }
    }
    catch {
        Log-Message "Error cleaning up Word application: $($_.Exception.Message)"
    }
    finally {
        # Release the COM object
        [System.Runtime.InteropServices.Marshal]::ReleaseComObject($WordApp)
        Remove-Variable -Name "WordApp"
        [gc]::Collect()
        [gc]::WaitForPendingFinalizers()
    }
}

# Create the XAML for the WPF UI
[xml]$xaml = @"
<Window 
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Word to PDF Converter" Height="500" Width="700" WindowStartupLocation="CenterScreen">
    <Grid Margin="10">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="Auto"/>
            <ColumnDefinition Width="*"/>
            <ColumnDefinition Width="Auto"/>
        </Grid.ColumnDefinitions>

        <!-- Header -->
        <TextBlock Grid.Row="0" Grid.Column="0" Grid.ColumnSpan="3" 
                   Text="Convert Word Documents to PDF and Back" 
                   FontWeight="Bold" FontSize="16" Margin="0,0,0,15"/>

        <!-- Source Folder -->
        <Label Grid.Row="1" Grid.Column="0" Content="Source Folder:" VerticalAlignment="Center"/>
        <TextBox Grid.Row="1" Grid.Column="1" Name="SourceFolderTextBox" Margin="5" Padding="5"/>
        <Button Grid.Row="1" Grid.Column="2" Content="Browse..." Name="BrowseSourceButton" Margin="5" Padding="5,2"/>

        <!-- Destination Folder -->
        <Label Grid.Row="2" Grid.Column="0" Content="Destination Folder:" VerticalAlignment="Center"/>
        <TextBox Grid.Row="2" Grid.Column="1" Name="DestinationFolderTextBox" Margin="5" Padding="5"/>
        <Button Grid.Row="2" Grid.Column="2" Content="Browse..." Name="BrowseDestButton" Margin="5" Padding="5,2"/>

        <!-- Include Subfolders -->
        <CheckBox Grid.Row="3" Grid.Column="0" Grid.ColumnSpan="3" 
                  Name="IncludeSubfoldersCheckBox" Content="Include Subfolders" 
                  Margin="5,10,0,10"/>

        <!-- PDFs to DOCX -->
        <CheckBox Grid.Row="4" Grid.Column="0" Grid.ColumnSpan="3" 
                  Name="ConvertPdfToDocxCheckBox" Content="Also convert PDFs to DOCX" 
                  Margin="5,0,0,10" IsChecked="True"/>

        <!-- Log Output -->
        <TextBox Grid.Row="5" Grid.Column="0" Grid.ColumnSpan="3" 
                 Name="LogTextBox" Margin="5" 
                 IsReadOnly="True" TextWrapping="Wrap" 
                 VerticalScrollBarVisibility="Auto"
                 FontFamily="Consolas"/>

        <!-- Progress Bar -->
        <ProgressBar Grid.Row="6" Grid.Column="0" Grid.ColumnSpan="3" 
                     Name="ProgressBar" Height="20" Margin="5"/>

        <!-- Buttons -->
        <StackPanel Grid.Row="7" Grid.Column="0" Grid.ColumnSpan="3" 
                    Orientation="Horizontal" HorizontalAlignment="Right" Margin="0,10,0,0">
            <Button Name="ConvertButton" Content="Convert" Width="100" Margin="0,0,10,0" Padding="5"/>
            <Button Name="CancelButton" Content="Cancel" Width="100" Margin="0,0,0,0" Padding="5"/>
        </StackPanel>
    </Grid>
</Window>
"@

# Create a form reader
$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

# Find all controls
$sourceFolder = $window.FindName("SourceFolderTextBox")
$destinationFolder = $window.FindName("DestinationFolderTextBox")
$browseSourceButton = $window.FindName("BrowseSourceButton")
$browseDestButton = $window.FindName("BrowseDestButton")
$includeSubfolders = $window.FindName("IncludeSubfoldersCheckBox")
$convertPdfToDocx = $window.FindName("ConvertPdfToDocxCheckBox")
$script:logTextBox = $window.FindName("LogTextBox")
$progressBar = $window.FindName("ProgressBar")
$convertButton = $window.FindName("ConvertButton")
$cancelButton = $window.FindName("CancelButton")

# Flag to track cancellation requests
$script:cancelRequested = $false

# Browse for source folder
$browseSourceButton.Add_Click({
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Select Source Folder"
    if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $sourceFolder.Text = $folderBrowser.SelectedPath
    }
})

# Browse for destination folder
$browseDestButton.Add_Click({
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Select Destination Folder"
    if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $destinationFolder.Text = $folderBrowser.SelectedPath
    }
})

# Set up cancel button
$cancelButton.Add_Click({
    $script:cancelRequested = $true
    Log-Message "Cancellation requested. Waiting for current operation to complete..."
    $cancelButton.IsEnabled = $false
    $cancelButton.Content = "Cancelling..."
})

# Main conversion function
function Start-Conversion {
    $script:cancelRequested = $false
    $convertButton.IsEnabled = $false
    $cancelButton.IsEnabled = $true
    $progressBar.Value = 0
    
    $sourcePath = $sourceFolder.Text
    $destPath = $destinationFolder.Text
    
    # Validate folders
    if (-not (Test-Path -Path $sourcePath -PathType Container)) {
        [System.Windows.MessageBox]::Show("Source folder does not exist.", "Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
        $convertButton.IsEnabled = $true
        $cancelButton.IsEnabled = $true
        return
    }
    
    if (-not (Test-Path -Path $destPath -PathType Container)) {
        try {
            New-Item -ItemType Directory -Path $destPath | Out-Null
            Log-Message "Created destination folder $destPath."
        } catch {
            [System.Windows.MessageBox]::Show("Could not create destination folder: $_", "Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
            $convertButton.IsEnabled = $true
            $cancelButton.IsEnabled = $true
            return
        }
    }
    
    # Start conversion process in a new runspace to keep UI responsive
    $convertParams = @{
        SourcePath = $sourcePath
        DestPath = $destPath
        IncludeSubfolders = $includeSubfolders.IsChecked
        ConvertPdfToDocx = $convertPdfToDocx.IsChecked
    }
    
    # Run conversion in background thread
    $runspace = [runspacefactory]::CreateRunspace()
    $runspace.ApartmentState = [System.Threading.ApartmentState]::STA
    $runspace.ThreadOptions = [System.Management.Automation.Runspaces.PSThreadOptions]::UseNewThread
    $runspace.Open()
    
    # Add necessary variables to runspace
    $runspace.SessionStateProxy.SetVariable('convertParams', $convertParams)
    $runspace.SessionStateProxy.SetVariable('script:logTextBox', $script:logTextBox)
    $runspace.SessionStateProxy.SetVariable('script:cancelRequested', [ref]$script:cancelRequested)
    $runspace.SessionStateProxy.SetVariable('progressBar', $progressBar)
    $runspace.SessionStateProxy.SetVariable('window', $window)
    $runspace.SessionStateProxy.SetVariable('convertButton', $convertButton)
    $runspace.SessionStateProxy.SetVariable('cancelButton', $cancelButton)
    $runspace.SessionStateProxy.SetVariable('logFile', $logFile)
    
    $powershell = [powershell]::Create()
    $powershell.Runspace = $runspace
    
    # Add the script to execute
    $script = {
        param($convertParams)
        
        function Log-Message {
            param([string]$message)
            
            $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            $logEntry = "$timestamp - $message"
            Add-Content -Path $logFile -Value $logEntry
            
            # Update UI
            $script:logTextBox.Dispatcher.Invoke([action]{
                $script:logTextBox.AppendText("$logEntry`r`n")
                $script:logTextBox.ScrollToEnd()
            })
        }
        
        function Update-Progress {
            param(
                [int]$PercentComplete,
                [string]$Status
            )
            
            $progressBar.Dispatcher.Invoke([action]{
                $progressBar.Value = $PercentComplete
            })
            
            Log-Message $Status
        }
        
        try {
            # Get Word files
            $getFilesParams = @{
                Path = Join-Path -Path $convertParams.SourcePath -ChildPath "*"
                Include = @("*.doc", "*.docx")
            }
            
            if ($convertParams.IncludeSubfolders) {
                $getFilesParams.Add("Recurse", $true)
            }
            
            Update-Progress -PercentComplete 5 -Status "Finding Word documents..."
            $wordFiles = Get-ChildItem @getFilesParams
            
            if ($wordFiles.Count -eq 0) {
                Update-Progress -PercentComplete 100 -Status "No Word documents found."
                return
            }
            
            Update-Progress -PercentComplete 10 -Status "Found $($wordFiles.Count) Word documents."
            
            # Create Word application
            $wordApp = New-Object -ComObject Word.Application
            $wordApp.Visible = $false
            
            # Process Word files
            $totalFiles = $wordFiles.Count
            $processedCount = 0
            
            foreach ($file in $wordFiles) {
                if ($script:cancelRequested.Value) {
                    Log-Message "Conversion cancelled by user."
                    break
                }
                
                $processedCount++
                $percentComplete = [math]::Min(10 + (($processedCount / $totalFiles) * 45), 55)
                Update-Progress -PercentComplete $percentComplete -Status "Converting $($file.Name) to PDF..."
                
                try {
                    $doc = $wordApp.Documents.Open($file.FullName)
                    $pdfPath = Join-Path -Path $convertParams.DestPath -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension($file.Name) + ".pdf")
                    $doc.SaveAs([ref] ([string]$pdfPath), [ref] 17) # 17 is the format code for PDF
                    $doc.Close()
                    Log-Message "Converted $($file.FullName) to $pdfPath."
                } catch {
                    Log-Message "Failed to convert $($file.FullName) to PDF. Error: $_"
                }
            }
            
            # Process PDF to DOCX if enabled
            if ($convertParams.ConvertPdfToDocx -and -not $script:cancelRequested.Value) {
                Update-Progress -PercentComplete 60 -Status "Finding PDF files for DOCX conversion..."
                $pdfFiles = Get-ChildItem -Path $convertParams.DestPath -Filter "*.pdf"
                
                if ($pdfFiles.Count -eq 0) {
                    Update-Progress -PercentComplete 100 -Status "No PDF files found for DOCX conversion."
                } else {
                    $totalPdfs = $pdfFiles.Count
                    $processedPdfs = 0
                    
                    foreach ($pdfFile in $pdfFiles) {
                        if ($script:cancelRequested.Value) {
                            Log-Message "Conversion cancelled by user."
                            break
                        }
                        
                        $processedPdfs++
                        $percentComplete = [math]::Min(60 + (($processedPdfs / $totalPdfs) * 35), 95)
                        Update-Progress -PercentComplete $percentComplete -Status "Converting $($pdfFile.Name) to DOCX..."
                        
                        try {
                            $pdfDoc = $wordApp.Documents.Open($pdfFile.FullName)
                            $docxPath = Join-Path -Path $convertParams.DestPath -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension($pdfFile.Name) + ".docx")
                            $pdfDoc.SaveAs([ref] ([string]$docxPath), [ref] 16) # 16 is the format code for DOCX
                            $pdfDoc.Close()
                            Log-Message "Converted $($pdfFile.FullName) to $docxPath."
                        } catch {
                            Log-Message "Failed to convert $($pdfFile.FullName) to DOCX. Error: $_"
                        }
                    }
                }
            }
            
            # Cleanup Word
            try {
                if ($wordApp -ne $null) {
                    # Close all documents
                    if ($wordApp.Documents -ne $null) {
                        foreach ($Document in $wordApp.Documents) {
                            try {
                                $Document.Close([ref]$false) # Don't save changes
                                [System.Runtime.InteropServices.Marshal]::ReleaseComObject($Document) | Out-Null
                            }
                            catch {
                                Log-Message "Error closing document: $($_.Exception.Message)"
                            }
                        }
                    }

                    # Quit Word
                    $wordApp.Quit()
                    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($wordApp) | Out-Null
                    [gc]::Collect()
                    [gc]::WaitForPendingFinalizers()
                    Log-Message "Word application closed."
                }
            }
            catch {
                Log-Message "Error cleaning up Word: $_"
            }
            
            Update-Progress -PercentComplete 100 -Status "Conversion completed!"
        }
        catch {
            Log-Message "Error during conversion: $_"
        }
        finally {
            # Re-enable UI controls
            $window.Dispatcher.Invoke([action]{
                $convertButton.IsEnabled = $true
                $cancelButton.IsEnabled = $true
                $cancelButton.Content = "Cancel"
            })
        }
    }
    
    $powershell.AddScript($script).AddArgument($convertParams)
    
    # Begin invoke
    $handle = $powershell.BeginInvoke()
}

# Set up convert button click event
$convertButton.Add_Click({
    Start-Conversion
})

# Show the UI
$window.ShowDialog() | Out-Null