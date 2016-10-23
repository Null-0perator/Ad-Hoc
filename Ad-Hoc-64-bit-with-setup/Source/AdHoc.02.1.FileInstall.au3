$FO[0] = FileOpen($File[0], 2+8)
For $i = 0 To 9
   FileWrite($FO[0], 'FileInstall("Resources\Pic' & $i & '.jpg", $Dir[0])' & @CRLF)
Next
FileClose($FO[0])

$FO[0] = FileOpen($File[21], 2+8)
FileWrite($FO[0], 'FileInstall("Resources\Pic10.jpg", $Dir[0])' & @CRLF)
FileClose($FO[0])
