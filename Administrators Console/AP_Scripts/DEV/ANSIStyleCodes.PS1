# Description: This script demonstrates how to use ANSI escape codes to style text in PowerShell. 
# It defines alias variables for common ANSI escape codes and uses them to print text with different styles and colors. 
# The script also provides a list of ANSI styles that can be used in PowerShell.
# B.Lowry/2024
Clear-Host
Write-Host "                `e[35;4;42mBelow is a list of ANSI styles that can be used in PowerShell for styling text`e[0m"
Write-Host ""
Write-Host ("`e[4mPSStyle ref                                   : PS7ANSI           : ANSI code1                : ANSI code2`e[0m") -ForegroundColor Blue
Write-Host ("Reset                                         : '``e`[0m'           : `$([char]27)[0m            : `$([char]0x1b)[0m")
Write-Host ("`e[31mRed Text`e[0m                                      : '``e[31m'          : `$([char]27)[31m           : `$([char]0x1b)[31m")
Write-Host ("`e[25mBlinkOff`e[0m                                      : '``e[25m'          : `$([char]27)[25m           : `$([char]0x1b)[25m")
Write-Host ("`e[5mBlink`e[0m                                         : '``e[5m'           : `$([char]27)[5m            : `$([char]0x1b)[5m")
Write-Host ("`e[22mBoldOff`e[0m                                       : '``e[22m'          : `$([char]27)[22m           : `$([char]0x1b)[22m")
Write-Host ("`e[1mBold`e[0m                                          : '``e[1m'           : `$([char]27)[1m            : `$([char]0x1b)[1m")
Write-Host ("`e[22mDimOff`e[0m                                        : '``e[22m'          : `$([char]27)[22m           : `$([char]0x1b)[22m")
Write-Host ("`e[2mDim`e[0m                                           : '``e[2m'           : `$([char]27)[2m            : `$([char]0x1b)[2m")
Write-Host ("`e[8mHidden`e[0m                                        : '``e[8m'           : `$([char]27)[8m            : `$([char]0x1b)[8m")
Write-Host ("`e[28mHiddenOff`e[0m                                     : '``e[28m'          : `$([char]27)[28m           : `$([char]0x1b)[28m")
Write-Host ("`e[7mReverse`e[0m                                       : '``e[7m'           : `$([char]27)[7m            : `$([char]0x1b)[7m")
Write-Host ("`e[27mReverseOff`e[0m                                    : '``e[27m'          : `$([char]27)[27m           : `$([char]0x1b)[27m")
Write-Host ("`e[23mItalicOff`e[0m                                     : '``e[23m'          : `$([char]27)[23m           : `$([char]0x1b)[23m")
Write-Host ("`e[3mItalic`e[0m                                        : '``e[3m'           : `$([char]27)[3m            : `$([char]0x1b)[3m")
Write-Host ("`e[24mUnderlineOff`e[0m                                  : '``e[24m'          : `$([char]27)[24m           : `$([char]0x1b)[24m")
Write-Host ("`e[4mUnderline`e[0m                                     : '``e[4m'           : `$([char]27)[4m            : `$([char]0x1b)[4m")
Write-Host ("`e[29mStrikethroughOff`e[0m                              : '``e[29m'          : `$([char]27)[29m           : `$([char]0x1b)[29m")
Write-Host ("`e[9mStrikethrough`e[0m                                 : '``e[9m'           : `$([char]27)[9m            : `$([char]0x1b)[9m")
Write-Host ("`e[32;1mFormatting.FormatAccent`e[0m                       : '``e[32;1m'        : `$([char]27)[32;1m         : `$([char]0x1b)[32;1m")
Write-Host ("`e[36;1mFormatting.ErrorAccent`e[0m                        : '``e[36;1m'        : `$([char]27)[36;1m         : `$([char]0x1b)[36;1m")
Write-Host ("`e[31;1mFormatting.Error`e[0m                              : '``e[31;1m'        : `$([char]27)[31;1m         : `$([char]0x1b)[31;1m")
Write-Host ("`e[33;1mFormatting.Warning`e[0m                            : '``e[33;1m'        : `$([char]27)[33;1m         : `$([char]0x1b)[33;1m")
Write-Host ("`e[33;1mFormatting.Verbose`e[0m                            : '``e[33;1m'        : `$([char]27)[33;1m         : `$([char]0x1b)[33;1m")
Write-Host ("`e[33;1mFormatting.Debug`e[0m                              : '``e[33;1m'        : `$([char]27)[33;1m         : `$([char]0x1b)[33;1m")
Write-Host ("`e[32;1mFormatting.TableHeader`e[0m                        : '``e[32;1m'        : `$([char]27)[32;1m         : `$([char]0x1b)[32;1m")
Write-Host ("`e[32;1;3mFormatting.CustomTableHeaderLabel`e[0m             : '``e[32;1;3m'      : `$([char]27)[32;1;3m       : `$([char]0x1b)[32;1;3m")
Write-Host ("`e[33mFormatting.FeedbackName`e[0m                       : '``e[33m'          : `$([char]27)[33m           : `$([char]0x1b)[33m")
Write-Host ("`e[96mFormatting.FeedbackText`e[0m                       : '``e[96m'          : `$([char]27)[96m           : `$([char]0x1b)[96m")
Write-Host ("`e[33;1mProgress.Style`e[0m                                : '``e[33;1m'        : `$([char]27)[33;1m         : `$([char]0x1b)[33;1m")
Write-Host ("`e[44;1mFileInfo.Directory`e[0m                            : '``e[44;1m'        : `$([char]27)[44;1m         : `$([char]0x1b)[44;1m")
Write-Host ("`e[36;1mFileInfo.SymbolicLink`e[0m                         : '``e[36;1m'        : `$([char]27)[36;1m         : `$([char]0x1b)[36;1m")
Write-Host ("`e[32;1mFileInfo.Executable`e[0m                           : '``e[32;1m'        : `$([char]27)[32;1m         : `$([char]0x1b)[32;1m")
Write-Host ("`e[30mForeground.Black`e[0m                              : '``e[30m'          : `$([char]27)[30m           : `$([char]0x1b)[30m")
Write-Host ("`e[90mForeground.BrightBlack`e[0m                        : '``e[90m'          : `$([char]27)[90m           : `$([char]0x1b)[90m")
Write-Host ("`e[37mForeground.White`e[0m                              : '``e[37m'          : `$([char]27)[37m           : `$([char]0x1b)[37m")
Write-Host ("`e[97mForeground.BrightWhite`e[0m                        : '``e[97m'          : `$([char]27)[97m           : `$([char]0x1b)[97m")
Write-Host ("`e[31mForeground.Red`e[0m                                : '``e[31m'          : `$([char]27)[31m           : `$([char]0x1b)[31m")
Write-Host ("`e[91mForeground.BrightRed`e[0m                          : '``e[91m'          : `$([char]27)[91m           : `$([char]0x1b)[91m")
Write-Host ("`e[35mForeground.Magenta`e[0m                            : '``e[35m'          : `$([char]27)[35m           : `$([char]0x1b)[35m")
Write-Host ("`e[95mForeground.BrightMagenta`e[0m                      : '``e[95m'          : `$([char]27)[95m           : `$([char]0x1b)[95m")
Write-Host ("`e[34mForeground.Blue`e[0m                               : '``e[34m'          : `$([char]27)[34m           : `$([char]0x1b)[34m")
Write-Host ("`e[94mForeground.BrightBlue`e[0m                         : '``e[94m'          : `$([char]27)[94m           : `$([char]0x1b)[94m")
Write-Host ("`e[36mForeground.Cyan`e[0m                               : '``e[36m'          : `$([char]27)[36m           : `$([char]0x1b)[36m")
Write-Host ("`e[96mForeground.BrightCyan`e[0m                         : '``e[96m'          : `$([char]27)[96m           : `$([char]0x1b)[96m")
Write-Host ("`e[32mForeground.Green`e[0m                              : '``e[32m'          : `$([char]27)[32m           : `$([char]0x1b)[32m")
Write-Host ("`e[92mForeground.BrightGreen`e[0m                        : '``e[92m'          : `$([char]27)[92m           : `$([char]0x1b)[92m")
Write-Host ("`e[33mForeground.Yellow`e[0m                             : '``e[33m'          : `$([char]27)[33m           : `$([char]0x1b)[33m")
Write-Host ("`e[93mForeground.BrightYellow`e[0m                       : '``e[93m'          : `$([char]27)[93m           : `$([char]0x1b)[93m")
Write-Host ("`e[40mBackground.Black`e[0m                              : '``e[40m'          : `$([char]27)[40m           : `$([char]0x1b)[40m")
Write-Host ("`e[100mBackground.BrightBlack`e[0m                        : '``e[100m'         : `$([char]27)[100m          : `$([char]0x1b)[100m")
Write-Host ("`e[47mBackground.White`e[0m                              : '``e[47m'          : `$([char]27)[47m           : `$([char]0x1b)[47m")
Write-Host ("`e[107mBackground.BrightWhite`e[0m                        : '``e[107m'         : `$([char]27)[107m          : `$([char]0x1b)[107m")
Write-Host ("`e[41mBackground.Red`e[0m                                : '``e[41m'          : `$([char]27)[41m           : `$([char]0x1b)[41m")
Write-Host ("`e[101mBackground.BrightRed`e[0m                          : '``e[101m'         : `$([char]27)[101m          : `$([char]0x1b)[101m")
Write-Host ("`e[45mBackground.Magenta`e[0m                            : '``e[45m'          : `$([char]27)[45m           : `$([char]0x1b)[45m")
Write-Host ("`e[105mBackground.BrightMagenta`e[0m                      : '``e[105m'         : `$([char]27)[105m          : `$([char]0x1b)[105m")
Write-Host ("`e[44mBackground.Blue`e[0m                               : '``e[44m'          : `$([char]27)[44m           : `$([char]0x1b)[44m")
Write-Host ("`e[104mBackground.BrightBlue`e[0m                         : '``e[104m'         : `$([char]27)[104m          : `$([char]0x1b)[104m")
Write-Host ("`e[46mBackground.Cyan`e[0m                               : '``e[46m'          : `$([char]27)[46m           : `$([char]0x1b)[46m")
Write-Host ("`e[106mBackground.BrightCyan`e[0m                         : '``e[106m'         : `$([char]27)[106m          : `$([char]0x1b)[106m")
Write-Host ("`e[42mBackground.Green`e[0m                              : '``e[42m'          : `$([char]27)[42m           : `$([char]0x1b)[42m")
Write-Host ("`e[102mBackground.BrightGreen `e[0m                       : '``e[102m'         : `$([char]27)[102m          : `$([char]0x1b)[102m")
Write-Host ("`e[43mBackground.Yellow`e[0m                             : '``e[43m'          : `$([char]27)[43m           : `$([char]0x1b)[43m")
Write-Host ("`e[103mBackground.BrightYellow`e[0m                       : '``e[103m'         : `$([char]27)[103m          : `$([char]0x1b)[103m")
Write-Host ("Progress.MaxWidth                             : 120")
Write-Host ("Progress.View                                 : Minimal")
Write-Host ("Progress.UseOSCIndicator                      : False")
Write-Host ("FileInfo.Extension                            : .zip,.tgz,.gz,.tar,.nupkg,.cab,.7z,.ps1,.psd1,.psm1,.ps1xml")
Write-Host ""
Write-Host ""

# Using RGB Values
Write-Host "`e[1;4;35mSet a foreground or background color from a set of RGB values:`e[0m"
Write-Host "`$PSStyle.Foreground.FromRgb(0,200,100)" -ForegroundColor Green
Write-Host "Write-Host `"`$(`$PSStyle.Foreground.FromRgb(0,200,100))I am the walrus`$(`$PSStyle.Reset)`""
Write-Host "$($PSStyle.Foreground.FromRgb(255,105,180))I am the walrus (255,105,180)$($PSStyle.Reset)"
Write-Host "$($PSStyle.Foreground.FromRgb(105,5,206))I am the walrus (105,5,206)$($PSStyle.Reset)"
Write-Host "$($PSStyle.Foreground.FromRgb(60,255,0))I am the walrus (60,255,0)$($PSStyle.Reset)"
Write-Host "$($PSStyle.Foreground.FromRgb(201,114,0))I am the walrus (201,114,0)$($PSStyle.Reset)"
Write-Host ""
Write-Host ""

# My set of variables for this document
$reset      = "$([char]27)[0m"
$bold       = "$([char]27)[1m"
$underline  = "$([char]27)[4m"
$red        = "$([char]27)[31m"
$green      = "$([char]27)[32m"
$yellow     = "$([char]27)[33m"
$blue       = "$([char]27)[34m"
$magenta    = "$([char]27)[35m"
$cyan       = "$([char]27)[36m"
$white      = "$([char]27)[37m"
$bgRed      = "$([char]27)[41m"
$bgGreen    = "$([char]27)[42m"
$bgYellow   = "$([char]27)[43m"
$bgBlue     = "$([char]27)[44m"
$bgMagenta  = "$([char]27)[45m"
$bgCyan     = "$([char]27)[46m"
$bgWhite    = "$([char]27)[47m"
$blink      = "$([char]27)[5m"

# Apply the variables to text describing the variables.
Write-Host "`e[1;4;35m1. Define ANSI escape code alias variables`e[0m"
Write-Host "`$reset      = '`$([char]27)[0m'"
Write-Host "`$bold       = '`$([char]27)[1m'"
Write-Host "`$underline  = '`$([char]27)[4m'"
Write-Host "`$red        = '`$([char]27)[31m'"
Write-Host "`$green      = '`$([char]27)[32m'"
Write-Host "`$yellow     = '`$([char]27)[33m'"
Write-Host "`$blue       = '`$([char]27)[34m'"
Write-Host "`$magenta    = '`$([char]27)[35m'"
Write-Host "`$cyan       = '`$([char]27)[36m'"
Write-Host "`$white      = '`$([char]27)[37m'"
Write-Host "`$bgRed      = '`$([char]27)[41m'"
Write-Host "`$bgGreen    = '`$([char]27)[42m'"
Write-Host "`$bgYellow   = '`$([char]27)[43m'"
Write-Host "`$bgBlue     = '`$([char]27)[44m'"
Write-Host "`$bgMagenta  = '`$([char]27)[45m'"
Write-Host "`$bgCyan     = '`$([char]27)[46m'"
Write-Host "`$bgWhite    = '`$([char]27)[47m'"
Write-Host "`$blink      = '`$([char]27)[5m'"
Write-Host ""
Write-Host ""
# example syntax with the applied effect
Write-Host "`e[1;4;35m2. Print text with different styles and colors using aliases`e[0m"
Write-Host "$bold`$bold Bold Text `$reset $reset"
Write-Host "$underline`$underline Underlined Text `$reset $reset"
Write-Host "$red`$red Red Text `$reset $reset"
Write-Host "$green`$green Green Text `$reset $reset"
Write-Host "$yellow`$yellow Yellow Text `$reset $reset"
Write-Host "$blue`$blue Blue Text `$reset $reset"
Write-Host "$magenta`$magenta Magenta Text `$reset $reset"
Write-Host "$cyan`$cyan Cyan Text `$reset $reset"
Write-Host "$white`$white White Text `$reset $reset"
Write-Host "$bgRed`$bgRed Background Red `$reset $reset"
Write-Host "$bgGreen`$bgGreen Background Green `$reset $reset"
Write-Host "$bgYellow`$bgYellow Background Yellow `$reset $reset"
Write-Host "$bgBlue`$bgBlue Background Blue `$reset $reset"
Write-Host "$bgMagenta`$bgMagenta Background Magenta `$reset $reset"
Write-Host "$bgCyan`$bgCyan Background Cyan `$reset $reset"
Write-Host "$bgWhite`$bgWhite Background White `$reset $reset"
Write-Host "$blink`$blink blink `$reset $reset"
Write-Host ""
Write-Host ""
# Give some examples of proper syntax for reference
Write-Host "`e[1;4;35mUsage and Syntax Examples:`e[0m"
Write-Host "$underline`PSStyle:$reset"
Write-Host "Write-Host '`$(`$psstyle.Foreground.Red)This text is red`$(`$psstyle.Reset)'"
Write-Host ""
Write-Host "$underline`PS7 ANSI$reset"
Write-Host "Write-Host ('``e[31mThis text is red``e[0m')"
Write-Host ""
Write-Host "$underline`ANSI Code1$reset"
Write-Host "Write-Host ('`$([char]27)[31mThis text is red`$([char]27)[0m')"
Write-Host ""
Write-Host "$underline`ANSI Code2$reset"
Write-Host "Write-Host ('`$([char]0x1b)[31mThis text is red`$([char]0x1b)[0m')"
Write-Host ""
Write-Host ""
Read-host "`e[5;31mPress [Enter] to exit`e[0m"



<# Correct:
Write-Host ("$([char]27)[31mThis text is red$([char]27)[0m")
Write-Host ("$([char]0x1b)[31mThis text is red$([char]0x1b)[0m")
Write-Host ("`e[31mThis text is red`e[0m")
Write-Host "$($psstyle.Foreground.Red)This text is red$($psstyle.Reset)"
#>#>


Write-Host ("$red This text is red $reset")