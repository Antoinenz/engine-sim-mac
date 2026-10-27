#include "../include/engine_picker.h"

#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <commdlg.h>

namespace {
    std::wstring toWide(const std::string &s) {
        const int length = MultiByteToWideChar(CP_UTF8, 0, s.c_str(), -1, nullptr, 0);
        std::wstring result(length, L'\0');
        MultiByteToWideChar(CP_UTF8, 0, s.c_str(), -1, &result[0], length);
        result.resize(length - 1);
        return result;
    }

    std::string toUtf8(const wchar_t *s) {
        const int length = WideCharToMultiByte(CP_UTF8, 0, s, -1, nullptr, 0, nullptr, nullptr);
        std::string result(length, '\0');
        WideCharToMultiByte(CP_UTF8, 0, s, -1, &result[0], length, nullptr, nullptr);
        result.resize(length - 1);
        return result;
    }
}

bool pickEngineFile(const std::string &startDirectory, std::string *path) {
    std::wstring initialDir = toWide(startDirectory);
    for (wchar_t &c : initialDir) {
        if (c == L'/') c = L'\\';
    }

    wchar_t fileName[MAX_PATH] = L"";

    OPENFILENAMEW ofn = {};
    ofn.lStructSize = sizeof(ofn);
    ofn.hwndOwner = GetActiveWindow();
    ofn.lpstrFilter = L"Engine scripts (*.mr)\0*.mr\0All files (*.*)\0*.*\0";
    ofn.lpstrFile = fileName;
    ofn.nMaxFile = MAX_PATH;
    ofn.lpstrInitialDir = initialDir.c_str();
    ofn.lpstrTitle = L"Choose an engine";
    // OFN_NOCHANGEDIR matters: the app resolves ../assets relative to the
    // working directory, which the dialog would otherwise change
    ofn.Flags = OFN_FILEMUSTEXIST | OFN_PATHMUSTEXIST | OFN_NOCHANGEDIR;

    if (!GetOpenFileNameW(&ofn)) return false;

    *path = toUtf8(fileName);
    return true;
}
