$Form1 = New-Object -TypeName System.Windows.Forms.Form
[System.Windows.Forms.Button]$Button1 = $null
[System.Windows.Forms.RichTextBox]$Main Window = $null
[System.Windows.Forms.RichTextBox]$RichTextBox = $null
[System.Windows.Forms.TextBox]$TextBox1 = $null
[System.Windows.Forms.Label]$Label1 = $null
function InitializeComponent
{
$resources = . (Join-Path $PSScriptRoot 'timerv2.resources.ps1')
$Button1 = (New-Object -TypeName System.Windows.Forms.Button)
$Main Window = (New-Object -TypeName System.Windows.Forms.RichTextBox)
$RichTextBox = (New-Object -TypeName System.Windows.Forms.RichTextBox)
$TextBox1 = (New-Object -TypeName System.Windows.Forms.TextBox)
$Label1 = (New-Object -TypeName System.Windows.Forms.Label)
$Form1.SuspendLayout()
#
#Button1
#
$Button1.BackColor = [System.Drawing.SystemColors]::Control
$Button1.DialogResult = [System.Windows.Forms.DialogResult]::OK
$Button1.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'SamsungOneUI Light Condensed',[System.Single]11.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Button1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]101,[System.Int32]183))
$Button1.Name = [System.String]'Button1'
$Button1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]28))
$Button1.TabIndex = [System.Int32]2
$Button1.Text = [System.String]'Find'
$Button1.UseCompatibleTextRendering = $true
$Button1.UseVisualStyleBackColor = $true
$Button1.add_Click($Button1_Click)
#
#Main Window
#
$Main Window.BackColor = [System.Drawing.SystemColors]::Desktop
$Main Window.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$Main Window.Dock = [System.Windows.Forms.DockStyle]::Top
$Main Window.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'SamsungOneUISCN 450',[System.Single]12,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Main Window.ForeColor = [System.Drawing.Color]::Red
$Main Window.HideSelection = $false
$Main Window.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]0,[System.Int32]0))
$Main Window.Name = [System.String]'Main Window'
$Main Window.ReadOnly = $true
$Main Window.RightMargin = [System.Int32]241
$Main Window.ScrollBars = [System.Windows.Forms.RichTextBoxScrollBars]::None
$Main Window.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]279,[System.Int32]119))
$Main Window.TabIndex = [System.Int32]6
$Main Window.Text = [System.String]'       Universal DHCP LauncherV1.5'
$Main Window.add_TextChanged($RichTextBox1_TextChanged)
#
#RichTextBox
#
$RichTextBox.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Arial Black',[System.Single]11.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$RichTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]217))
$RichTextBox.Name = [System.String]'RichTextBox'
$RichTextBox.ScrollBars = [System.Windows.Forms.RichTextBoxScrollBars]::None
$RichTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]255,[System.Int32]45))
$RichTextBox.TabIndex = [System.Int32]7
$RichTextBox.Text = [System.String]''
#
#TextBox1
#
$TextBox1.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Arial Narrow',[System.Single]11.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$TextBox1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]13,[System.Int32]153))
$TextBox1.Name = [System.String]'TextBox1'
$TextBox1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]255,[System.Int32]25))
$TextBox1.TabIndex = [System.Int32]8
$TextBox1.add_TextChanged($TextBox1_TextChanged)
#
#Label1
#
$Label1.BackColor = [System.Drawing.Color]::Black
$Label1.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Arial Black',[System.Single]8,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label1.ForeColor = [System.Drawing.Color]::White
$Label1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]13,[System.Int32]133))
$Label1.Name = [System.String]'Label1'
$Label1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]94,[System.Int32]17))
$Label1.TabIndex = [System.Int32]9
$Label1.Text = [System.String]'IP Address:'
#
#Form1
#
$Form1.AcceptButton = $Button1
$Form1.AutoScroll = $true
$Form1.AutoSize = $true
$Form1.BackColor = [System.Drawing.Color]::Black
$Form1.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]279,[System.Int32]277))
$Form1.Controls.Add($Label1)
$Form1.Controls.Add($TextBox1)
$Form1.Controls.Add($RichTextBox)
$Form1.Controls.Add($Main Window)
$Form1.Controls.Add($Button1)
$Form1.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Stencil',[System.Single]11.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Form1.Icon = ([System.Drawing.Icon]$resources.'$this.Icon')
$Form1.KeyPreview = $true
$Form1.SizeGripStyle = [System.Windows.Forms.SizeGripStyle]::Hide
$Form1.Text = [System.String]'Universal DHCP Launcher V1.5'
$Form1.TopMost = $true
$Form1.Visible = $true
$Form1.ResumeLayout($false)
$Form1.PerformLayout()
Add-Member -InputObject $Form1 -Name Button1 -Value $Button1 -MemberType NoteProperty
Add-Member -InputObject $Form1 -Name Main Window -Value $Main Window -MemberType NoteProperty
Add-Member -InputObject $Form1 -Name RichTextBox -Value $RichTextBox -MemberType NoteProperty
Add-Member -InputObject $Form1 -Name TextBox1 -Value $TextBox1 -MemberType NoteProperty
Add-Member -InputObject $Form1 -Name Label1 -Value $Label1 -MemberType NoteProperty
}
. InitializeComponent
