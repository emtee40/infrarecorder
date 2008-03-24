/*
 * Copyright (C) 2006-2008 Christian Kindahl, christian dot kindahl at gmail dot com
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 */

#pragma once
#include "resource.h"
#include "DropDownButton.h"
#include "../../Common/Log.h"

#define BOM_UTF8					0xEFBBBF
#define BOM_UTF32BE					0x0000FEFF
#define BOM_UTF32LE					0xFFFE0000
#define BOM_SCSU					0x0EFEFF

#define LOG_SAVE_BOM
#define LOG_WRITEBUFFER_SIZE		1024
#define LOG_LINEBUFFER_SIZE			512

class CLogDlg : public CDialogImpl<CLogDlg>,public CDialogResize<CLogDlg>,public CLog
{
private:
	CEdit m_LogEdit;
	CDropDownButton m_DiagButton;

	// This buffer will be used when creating the log line by the variable
	// argument list.
	TCHAR m_szLineBuffer[LOG_LINEBUFFER_SIZE];

	HANDLE m_hLogFile;
	void InitializeLogFile();

	bool Translate();
	bool SaveLog(const TCHAR *szFileName);

public:
	enum { IDD = IDD_LOGDLG };

	CLogDlg();
	~CLogDlg();

	void Show();
	void AddString(const TCHAR *szString,...);
	void AddLine(const TCHAR *szLine,...);

	// Resize maps.
	BEGIN_DLGRESIZE_MAP(CLogDlg)
		DLGRESIZE_CONTROL(IDOK,DLSZ_MOVE_X)
		DLGRESIZE_CONTROL(ID_SAVEASBUTTON,DLSZ_MOVE_X | DLSZ_MOVE_Y)
		DLGRESIZE_CONTROL(IDC_DIAGNOSTICSBUTTON,DLSZ_MOVE_X)
		DLGRESIZE_CONTROL(IDC_FILESBUTTON,DLSZ_MOVE_X)
		DLGRESIZE_CONTROL(IDC_LOGEDIT,DLSZ_SIZE_X | DLSZ_SIZE_Y)
	END_DLGRESIZE_MAP()

	// Events.
	BEGIN_MSG_MAP(CLogDlg)
		MESSAGE_HANDLER(WM_INITDIALOG,OnInitDialog)

		COMMAND_ID_HANDLER(IDOK,OnOK)
		COMMAND_ID_HANDLER(IDCANCEL,OnOK)
		COMMAND_ID_HANDLER(ID_SAVEASBUTTON,OnSaveAs)
		COMMAND_ID_HANDLER(IDC_FILESBUTTON,OnFiles)
		COMMAND_ID_HANDLER(ID_DIAGNOSTICS_DEVICESCAN,OnDiagDeviceScan)

		REFLECT_NOTIFICATIONS()
		CHAIN_MSG_MAP(CDialogResize<CLogDlg>)
	END_MSG_MAP()

	LRESULT OnInitDialog(UINT uMsg,WPARAM wParam,LPARAM lParam,BOOL &bHandled);
	LRESULT OnOK(WORD wNotifyCode,WORD wID,HWND hWndCtl,BOOL &bHandled);
	LRESULT OnSaveAs(WORD wNotifyCode,WORD wID,HWND hWndCtl,BOOL &bHandled);
	LRESULT OnDiagDeviceScan(WORD wNotifyCode,WORD wID,HWND hWndCtl,BOOL &bHandled);
	LRESULT OnFiles(WORD wNotifyCode,WORD wID,HWND hWndCtl,BOOL &bHandled);
};

extern CLogDlg g_LogDlg;