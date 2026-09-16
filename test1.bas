
     #COMPILER PBWIN 10
#COMPILE EXE
#DIM ALL

%IDD_DIALOG  = 3001
%IDC_TEXTBOX = 3002

'--- A Global Font Handle to ensure the font persists while the window is open
GLOBAL hMonoFont AS DWORD

'------------------------------------------------------------------------------
' Custom Function to Pad Data into Aligned Columns Dynamically
'------------------------------------------------------------------------------
FUNCTION PadCol(BYVAL TextData AS STRING, BYVAL ColWidth AS LONG) AS STRING
    ' Forces text to a precise width. Truncates if too long, spaces out if short.
    FUNCTION = LEFT$(TextData & SPACE$(ColWidth), ColWidth)
END FUNCTION

'------------------------------------------------------------------------------
' Callback Procedure
'------------------------------------------------------------------------------
CALLBACK FUNCTION DialogProc()
    LOCAL OutStr AS STRING

    SELECT CASE CB.MSG
        CASE %WM_INITDIALOG
            ' 1. Apply the Monospace Font to the Control
            CONTROL SET FONT CB.HNDL, %IDC_TEXTBOX, hMonoFont

            ' 2. Build Your Data Table Dynamically (Any Number of Columns)
            ' Row 1: Headers (Col 1: Width 8, Col 2: Width 25, Col 3: Width 10, Col 4: Width 12)
            OutStr = OutStr & PadCol("ID", 8) & PadCol("SYSTEM PROCESS", 25) & PadCol("STATUS", 10) & PadCol("MEMORY", 12) & $CRLF
            OutStr = OutStr & REPT$(55, "-") & $CRLF ' Underline separator

            ' Row 2 Data
            OutStr = OutStr & PadCol("X-101", 8) & PadCol("Database Cluster Core", 25) & PadCol("ONLINE", 10) & PadCol("42.5 MB", 12) & $CRLF

            ' Row 3 Data
            OutStr = OutStr & PadCol("X-102", 8) & PadCol("API Gateway Pipeline", 25) & PadCol("CRITICAL", 10) & PadCol("1,024.1 MB", 12) & $CRLF

            ' Row 4 Data
            OutStr = OutStr & PadCol("X-103", 8) & PadCol("Log Rotation Worker", 25) & PadCol("IDLE", 10) & PadCol("4.2 MB", 12) & $CRLF

            ' 3. Inject the clean text block into the Textbox
            TEXTBOX SET TEXT CB.HNDL, %IDC_TEXTBOX, OutStr

        CASE %WM_DESTROY
            ' Clean up font object memory when window closes
            FONT END hMonoFont

    END SELECT
END FUNCTION

'------------------------------------------------------------------------------
' Main Program Entry Point
'------------------------------------------------------------------------------
FUNCTION PBMAIN () AS LONG
    LOCAL hDlg AS DWORD

    ' Create the fixed-width font handle before opening the dialog
    FONT NEW "Consolas", 10, 0, 0, 0, 0 TO hMonoFont

    ' Design a pure container box. No close, no frame borders, no system menus.
    DIALOG NEW 0, "", , , 340, 90, %DS_MODALFRAME TO hDlg

    ' Add a read-only, multi-line, scrollable text field with NO control borders
    CONTROL ADD TEXTBOX, hDlg, %IDC_TEXTBOX, "", 5, 5, 330, 80, _
        %WS_CHILD OR %WS_VISIBLE OR %ES_MULTILINE OR %ES_READONLY OR %WS_VSCROLL OR %WS_HSCROLL

    DIALOG SHOW MODAL hDlg CALL DialogProc()
END FUNCTION
