
Clear-Host
$startTime = Get-Date
Write-Host "Start time:" -NoNewline 
Write-Host "  $startTime" -foregroundcolor "Yellow"
#Header
Write-Host ""
Write-Host "            *******************************             " -ForegroundColor yellow -BackgroundColor Blue
Write-Host "            *******************************             " -ForegroundColor yellow -BackgroundColor Blue
Write-Host "            ***** Collect Media Files *****             " -ForegroundColor yellow -BackgroundColor Blue
Write-Host "            *******************************             " -ForegroundColor yellow -BackgroundColor Blue
Write-Host "            *******************************             " -ForegroundColor yellow -BackgroundColor Blue
Write-Host ""
Write-Host ""
#Body
# Define the source and destination paths
$sourcePath = Read-Host -Prompt "Enter path to search"
$destinationPath = Read-Host -Prompt "Enter destination to copy files to"
$imageOutputCsv = $destinationPath + "\found_image_files.csv"
$videoOutputCsv = $destinationPath + "\found_video_files.csv"
$musicOutputCsv = $destinationPath + "\found_music_files.csv"
$mediaOutputCsv = $destinationPath + "\found_media_files.csv"
# Create the destination directory if it doesn't exist
if (-not (Test-Path -Path $destinationPath)) {
    Write-Host "Creating destination Directory"
    New-Item -ItemType Directory -Path $destinationPath
}
# Define the file extensions for images, videos, and sounds.
$imageExtensions = @("*.3dv", "*.amf", "*.ai", "*.awg", "*.ase", "*.art", "*.bmp", "*.blp", "*.bw", "*.cd5", "*.cgm", "*.cdr", "*.cmx", "*.cit", "*.cpt", "*.cr2", "*.cur", "*.cut", "*.dds", "*.dib", "*.djvu", "*.dxf", "*.e2d", "*.ecw", "*.egt", "*.eps", "*.egt", "*.emf", "*.exif", "*.fs", "*.gbr", "*.gif", "*.gpl", "*.grf", "*.hdp", "*.heic", "*.heif", "*.icns", "*.ico", "*.iff", "*.int", "*.inta", "*.jng", "*.jpeg", "*.jpg", "*.jfif", "*.jp2", "*.jps", "*.jxr", "*.lbm", "*.liff", "*.max", "*.miff", "*.mng", "*.msp", "*.nef", "*.nrrd", "*.nitf", "*.odg", "*.ota", "*.pam", "*.pcx", "*.pgf", "*.pbm", "*.pc1", "*.pc2", "*.pc3", "*.pcf", "*.pcx", "*.pdn", "*.pgm", "*.PI1", "*.PI2", "*.PI3", "*.pict", "*.pct", "*.png", "*.pnm", "*.pns", "*.ppm", "*.psb", "*.psd", "*.pdd", "*.psp", "*.px", "*.pxm", "*.pxr", "*.qfx", "*.raw", "*.rle", "*.ras", "*.rgb", "*.rgba", "*.sgi", "*.sun", "*.sid", "*.tga", "*.sxd", "*.svg", "*.stl", "*.sct", "*.rgb", "*.ras", "*.rgb", "*.rgba", "*.sgi", "*.sun", "*.sid", "*.tga", "*.tiff", "*.tif", "*.vrml", "*.vtf", "*.v2d", "*.vnd", "*.wdp", "*.webp", "*.wmf", "*.xar", "*.xbm", "*.xcf", "*.xpm", "*.x3d")
$videoExtensions = @("*.mp4", "*.avi", "*.mov", "*.wmv", "*.mkv", "*.flv", "*.3gp", "*.mpg")
$musicExtensions = @("*.MP3", "*.wav", "*.ogg", "*.AAC", "*.FLAC", "*.M4A", "*.WMA", "*.ALAC", "*.AIFF", "*.AIF")
# The code below uses a loop to continually prompt the user to select an option from a list of options until the user selects the Exit option:
# Initialize the $exit variable to $false
$exit = $false
# Choose file types to search for:
Write-host ""
Write-host ""
Write-host "What are we searching for today?" -ForegroundColor yellow
Write-host "  Choose from the numbers below:"
Write-host ""    
Write-host "    1. Images" -ForegroundColor Blue
Write-host "    2. Videos" -ForegroundColor Blue
Write-host "    3. Music/sound" -ForegroundColor Blue
Write-host "    4. All the above" -ForegroundColor Blue
Write-host "    5. Exit" -ForegroundColor red
Write-host "" 
Write-host ""
Write-host ""  
$choice = Read-Host -Prompt "    Choice: "
# Evaluate user input and execute option code.
switch ($choice) {
    "1" {
        # Initialize an array to store file information
        $imageFileList = @()
        # Search for files, print their paths, copy them to the destination, and add to the list
        foreach ($extension in $imageExtensions) {
            Get-ChildItem -Path $sourcePath -Recurse -Filter $extension | ForEach-Object {
                Write-host "Found: $($_.FullName)" -ForegroundColor red
                Copy-Item -Path $_.FullName -Destination $destinationPath
                $imageFileList += [PSCustomObject]@{
                    FileName = $_.Name
                    FilePath = $_.FullName
                }
            }
        }
        # Export the file list to a .csv file
        $imageFileList | Export-Csv -Path $imageOutputCsv -NoTypeInformation
        Write-Output "Files have been copied to $destinationPath and the list has been saved to $imageOutputCsv"
    };
    "2" {
        # Initialize an array to store file information
        $videoFileList = @()
        # Search for files, print their paths, copy them to the destination, and add to the list
        foreach ($extension in $videoExtensions) {
            Get-ChildItem -Path $sourcePath -Recurse -Filter $extension | ForEach-Object {
                Write-host "Found: $($_.FullName)" -ForegroundColor red
                Copy-Item -Path $_.FullName -Destination $destinationPath
                $videoFileList += [PSCustomObject]@{
                    FileName = $_.Name
                    FilePath = $_.FullName
                }
            }
        }
        # Export the file list to a .csv file
        $videoFileList | Export-Csv -Path $videoOutputCsv -NoTypeInformation
        Write-Output "Files have been copied to $destinationPath and the list has been saved to $videoOutputCsv"
    };
        
    "3" {
        # Initialize an array to store file information
        $musicFileList = @()
        # Search for files, print their paths, copy them to the destination, and add to the list
        foreach ($extension in $musicExtensions) {
            Get-ChildItem -Path $sourcePath -Recurse -Filter $extension | ForEach-Object {
                Write-host "Found: $($_.FullName)" -ForegroundColor red
                Copy-Item -Path $_.FullName -Destination $destinationPath
                $musicFileList += [PSCustomObject]@{
                    FileName = $_.Name
                    FilePath = $_.FullName
                }
            }
        }
        # Export the file list to a .csv file
        $musicFileList | Export-Csv -Path $musicOutputCsv -NoTypeInformation
        Write-Output "Files have been copied to $destinationPath and the list has been saved to $musicOutputCsv"
    };
    "4" {
        # Combine the extensions into one array
        $fileExtensions = $imageExtensions + $videoExtensions + $musicExtensions
        # Initialize an array to store file information
        $fileList = @()
        # Search for files, print their paths, copy them to the destination, and add to the list
        foreach ($extension in $fileExtensions) {
            Get-ChildItem -Path $sourcePath -Recurse -Filter $extension | ForEach-Object {
                Write-host "Found: $($_.FullName)" -ForegroundColor red
                Copy-Item -Path $_.FullName -Destination $destinationPath
                $fileList += [PSCustomObject]@{
                    FileName = $_.Name
                    FilePath = $_.FullName
                }
            }
        }
        # Export the file list to a .csv file
        $fileList | Export-Csv -Path $mediaOutputCsv -NoTypeInformation
        Write-Output "Files have been copied to $destinationPath and the list has been saved to $mediaOutputCsv"
    };
    "5" {
        # If the user selects option 5, set $exit to $true to exit the loop
        $exit = $true
    };
    default {
        Write-Host "Invalid selection. Please choose a valid option." -ForegroundColor Yellow
    }
}
#Script Execution Stats
$endTime = Get-Date
$executionTime = $endTime - $startTime
Write-Host "Script Completed:" -NoNewline
Write-Host "  $EndTime" -Foregroundcolor "Yellow"
Write-Host "Script execution time:" -NoNewline
Write-Host "  $executionTime" -foregroundcolor "yellow"
                                                                                                                                                                                                                           ��(x\E��X^T��|D�)�`0�VOܯK;�r���7h̍(��.�U[ȵ���;;x�.B�`�K�B�cx��zO9�$�"$�¢A�T��{[��'m�e�)J+����,H��m��XN¹=F�j�wdv�}����ǝ�X�am�MnZ�9x�6�5�SYo���8ƍ�Rݟ�ndބm����6t�HC����(�|~��������Z�ŨX t��]��b�5ۉ��0�V_R5��W�¤�������U��v�\�-Do,��Ɍ|���g>��*��3D-Zu��on����x��F��2���1��/��&�Jp4�TG��J�nD�$�.G�hP�x�� ��H���ν��/��`�b`��v9���Œ�<s2�ǔ���Т���*�`��j��ĥ|;���SH���,_wf��Ey\{ш��O`��X����D����">ԍ����,�]�۔��5���iQ��9�?�2��S��6��(��E>���<�G�g�
O[�i�[�?��o�y�bZ^�|�Z�����&��ӈ'[�<����:m�Uۻ3ϻOS�U��T�g�{�z��nRX�[[�r�)������S9i��lr�.�5W�0�,��~���Ӛ�MWx�x|x����cO�/����f	+m���Uq�*������&Nq5�A��� �h��*��#V�o�}��h폻x���@U)6��3��B����@�>
P�O8l�e�7NM?�� �B���$ym�C�^������<%��C֒���*ߣ���	�O,�[hW��g5��K��\���Y�2�FN0�� f�9�i�%�떾�h\4H��P>�X|±��	��@u#%��ܴ௻�Rg|���,z���5�y�5m��1��R���4�(�����lK���,����%J�LUF�	�#�tӼ�L(`���_,{����T�ԃ�Ŭ�&X4㨤�i��7�GFe��#�2#��m������-�o�/ZX��٥|���"B�����26`M����̿V2���hz/�&�MZ�v"���2f��(9K
5YKL��:��>Y'1�0�m"�! ��{��t����ܮ3��!�B�V7���(�I�|�=���þ_H��4`�=ߩ�F�-ϡ��*DG��o�h�;c�:�U���}�0o[�h�jB{?��J���Յ��$aE9���;�-t
�F������|Q�f���Go�p�X���}%���� ��^Mtq��ܶ`�Ŀy�E��*�R�v���|���2�R����"�P����I�G��-�������s��-vU,F���l�n��p��D}�.?�Շ�K5�k�ֳI���l���-c�͸+�,��V�t�рTN	�t-(�ro'[�k+$�(Xcc�%���ϪUd%[�Nd��V�������pr����i0.ZkZѩ�-��Ñ��N	Z'i�3pW����s��]fN�NN� ��� ��I�xt��Z�_�<�nfI<�=q�͘�x�m�Xm�\��,M
�ӯ��ZG�A����y��4�.����E��O)��r��?6��w�	�[#t�y�����������"��uZk4�V{����+㦏%{\f\����Q_�,�<�{�½�պ���+�U�F�܍9|w[�N�L��G=��EGF-�+�ǅ��]W8D7����
��ς�O�ȋ9A⭟�g��p��|n�Z�w�y��)J��zw\o!!$�#�oi�JVz���FǢk���xoА�3O�m��r������&���t͈�s�	1x�Hdi:�9�H�]�2K`/�e0�\o��"��˟>E�e�+ታ��`{q�9�AC;	s�r:��&q~���-o"m�Qi("{ ���2��/i�||����N���e7�4"T�Fb��Zs�����:r����%�s���8���zN)ΰAk���K
��|{�T���-]>��G�a��7��j0h1;�,a�؎ߍ<�5o8�7����-��c��A���$C���L�qwc���IrS��RqZP�����B��k��hkAZ((�&l�Y(O�0�[���un�Lc�'Ol�� ��\ �'�>��z9H�v�Ў���f����^�a=B(ԟ��<m�