cmake_minimum_required(VERSION 3.31.2)

project(psychological VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Sql)

qt_standard_project_setup(REQUIRES 6.9) #set(CMAKE_AUTOUIC ON)  set(CMAKE_AUTOMOC ON)

qt_add_executable(apppsychological)

qt_add_qml_module(apppsychological
    URI psychological
    VERSION 1.0
    SOURCES     main.cpp
    QML_FILES   Main.qml
    RESOURCES
    QML_FILES
    QML_FILES Login.qml
    QML_FILES StudentPage.qml
    QML_FILES TeacherPage.qml
    QML_FILES AdminPage.qml
    QML_FILES pageswitching.js
    QML_FILES CounselorChat.qml
    QML_FILES ConsultationLog.qml
    QML_FILES MentalHealthLibrary.qml
    QML_FILES PersonalCenter.qml
    QML_FILES MessageCenter.qml
    QML_FILES SelfEvaluation.qml
    QML_FILES StudentHome.qml
    QML_FILES studentManager.js
    QML_FILES teacherManager.js
    QML_FILES TeacherHome.qml
    QML_FILES ConsultationProcess.qml
    QML_FILES ConsultationRecords.qml
    QML_FILES ProfessionalResources.qml
    QML_FILES adminManager.js
    QML_FILES AdminHome.qml
    QML_FILES UserManagement.qml
    QML_FILES ConsultationSupervision.qml
    QML_FILES MentalLiterature.qml
    QML_FILES PsychologicalTests.qml
    SOURCES DatabaseHandler.h
    SOURCES DatabaseHandler.cpp
    # SOURCES databasemanager.h databasemanager.cpp
    SOURCES user.h user.cpp usermodel.cpp usermodel.h teacher.h teacher.cpp student.cpp student.h
    QML_FILES CustomDialogs.qml
    QML_FILES dialogManager.js
    #教师
    SOURCES teachermessagemodel.h teachermessagemodel.cpp
    SOURCES consultationlogmodel.h consultationlogmodel.cpp
)

source_group("QML Files" FILES
    Main.qml
)

source_group("Student Files" FILES
    StudentPage.qml CounselorChat.qml ConsultationLog.qml MentalHealthLibrary.qml
    PersonalCenter.qml MessageCenter.qml SelfEvaluation.qml StudentHome.qml
    studentManager.js
)

source_group("Teacher Files" FILES
    TeacherPage.qml teacherManager.js TeacherHome.qml ConsultationProcess.qml
    ConsultationRecords.qml StudentManagement.qml ProfessionalResources.qml
)

source_group("Admin Files" FILES
    AdminPage.qml adminManager.js AdminHome.qml
    ConsultationSupervision.qml UserManagement.qml
    MentalLiterature.qml  CustomDialogs.qml dialogManager.js
    PsychologicalTests.qml
)

target_compile_features(apppsychological PRIVATE cxx_std_23)

target_link_libraries(apppsychological
    PRIVATE
        Qt6::Quick
        Qt6::Sql
)

set_target_properties(apppsychological PROPERTIES
    AUTORCC TRUE                              #  set(CMAKE_AUTORCC ON)
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.apppsychological
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

include(GNUInstallDirs)
install(TARGETS apppsychological
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)


















































# set(CMAKE_CXX_STANDARD_REQUIRED ON) # Globally preventing the fallback behaviour of C++ standard
#qt_add_executable(psychological)  //Creates and finalizes an application target of a platform-specific type.
#This command performs the following tasks:
#    1. Create a CMake target of the appropriate type for the target platform.
#    2. Link the target to the Qt::Core library.
#    3. Handle finalization of the CMake target.

# set(CMAKE_CXX_STANDARD_REQUIRED ON) # Globally preventing the fallback behaviour of C++ standard

# qt_standard_project_setup()  #set(CMAKE_AUTOUIC ON)  set(CMAKE_AUTOMOC ON)






# cmake_minimum_required(VERSION 3.16)
#
# project(psychological VERSION 0.1 LANGUAGES CXX)
#
# @if !true
# set(CMAKE_AUTOMOC ON)
# @endif
# set(CMAKE_CXX_STANDARD_REQUIRED ON)
#
# find_package(Qt6 REQUIRED COMPONENTS Quick)
#
# @if true
# @if true
# qt_standard_project_setup(REQUIRES 6.9)
# @else
# qt_standard_project_setup()
# @endif
# @endif
#
# qt_add_executable(apppsychological
#     main.cpp
# )
#
# qt_add_qml_module(apppsychological
#     URI psychological
#     VERSION 1.0
#     QML_FILES
#         Main.qml
# )
#
# # Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# # If you are developing for iOS or macOS you should consider setting an
# # explicit, fixed bundle identifier manually though.
# set_target_properties(apppsychological PROPERTIES
# #    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.apppsychological
#     MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
#     MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
#     MACOSX_BUNDLE TRUE
#     WIN32_EXECUTABLE TRUE
# )
#
# target_link_libraries(apppsychological
#     PRIVATE Qt6::Quick
# )
#
# include(GNUInstallDirs)
# install(TARGETS apppsychological
#     BUNDLE DESTINATION .
#     LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
#     RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
# )
