#ifndef ATG_ENGINE_SIM_ENGINE_PICKER_H
#define ATG_ENGINE_SIM_ENGINE_PICKER_H

#include <string>

// Shows a native file dialog for choosing an engine script (.mr), starting in
// startDirectory. Returns false if the user cancelled or no dialog is
// available on this platform.
bool pickEngineFile(const std::string &startDirectory, std::string *path);

#endif /* ATG_ENGINE_SIM_ENGINE_PICKER_H */
