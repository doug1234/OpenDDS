function(opendds_add_test)
  set(no_value_options)
  set(single_value_options NAME)
  set(multi_value_options COMMAND ARGS EXTRA_LIB_DIRS)
  cmake_parse_arguments(arg
    "${no_value_options}" "${single_value_options}" "${multi_value_options}" ${ARGN})

  find_package(Perl REQUIRED)

  set(test_name "${PROJECT_NAME}_test")
  if(arg_NAME)
    set(test_name "${test_name}_${arg_NAME}")
  endif()
  if(NOT arg_COMMAND)
    set(arg_COMMAND ${PERL_EXECUTABLE} run_test.pl)
    if(CMAKE_CONFIGURATION_TYPES)
      list(APPEND arg_COMMAND $<$<BOOL:$<CONFIG>>:-ExeSubDir> $<CONFIG>)
    endif()
  endif()
  list(APPEND arg_COMMAND ${arg_ARGS})
  add_test(NAME "${test_name}" ${arg_UNPARSED_ARGUMENTS} COMMAND ${arg_COMMAND})

  set(env "ACE_ROOT=${ACE_ROOT}" "TAO_ROOT=${TAO_ROOT}")

  if(MSVC)
    set(env_var_name PATH)
  else()
    set(env_var_name LD_LIBRARY_PATH)
  endif()
  _opendds_path_list(lib_dir_list "$ENV{${env_var_name}}" "${TAO_LIB_DIR}")
  foreach(lib_dir "${OPENDDS_LIB_DIR}" ${arg_EXTRA_LIB_DIRS})
    _opendds_path_list(lib_dir_list "$ENV{${env_var_name}}" "${lib_dir}")
    if(CMAKE_CONFIGURATION_TYPES)
      _opendds_path_list(lib_dir_list
        "$ENV{${env_var_name}}" "${lib_dir}$<$<BOOL:$<CONFIG>>:/$<CONFIG>>")
    endif()
  endforeach()
  if(WIN32)
    string(REPLACE "/" "\\" lib_dir_list "${lib_dir_list}")
    string(REPLACE ";" "\;" lib_dir_list "${lib_dir_list}")
  endif()
  list(APPEND env "${env_var_name}=${lib_dir_list}")

  if(DEFINED OPENDDS_BUILD_DIR)
    list(APPEND env "OPENDDS_BUILD_DIR=${OPENDDS_BUILD_DIR}")
  endif()

  if(DEFINED OPENDDS_CONFIG_DIR)
    list(APPEND env "OPENDDS_CONFIG_DIR=${OPENDDS_CONFIG_DIR}")
  endif()

  if(DEFINED OPENDDS_SOURCE_DIR)
    if(NOT DEFINED ACE_SOURCE_DIR)
      set(ACE_SOURCE_DIR "${ACE_ROOT}")
    endif()
    _opendds_path_list(perl5lib "${OPENDDS_SOURCE_DIR}/bin" "${ACE_SOURCE_DIR}/bin")
    list(APPEND env "PERL5LIB=${perl5lib}")
    list(APPEND env "OPENDDS_SOURCE_DIR=${OPENDDS_SOURCE_DIR}")
  endif()

  if(env)
    set_property(TEST "${test_name}" PROPERTY ENVIRONMENT "${env}")
  endif()
endfunction()
