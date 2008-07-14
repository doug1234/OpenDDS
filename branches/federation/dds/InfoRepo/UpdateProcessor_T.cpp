// -*- C++ -*-
//
// $Id$
#ifndef UPDATEPROCESSOR__T_CPP
#define UPDATEPROCESSOR__T_CPP

#if !defined (ACE_LACKS_PRAGMA_ONCE)
#pragma once
#endif /* ACE_LACKS_PRAGMA_ONCE */

#include "DcpsInfo_pch.h"
#include "dds/DCPS/debug.h"
#include "UpdateProcessor_T.h"

namespace OpenDDS { namespace Federator {

template< class DataType>
UpdateProcessor< DataType>::UpdateProcessor()
{
  if( ::OpenDDS::DCPS::DCPS_debug_level > 0) {
    ACE_DEBUG((LM_DEBUG,
      ACE_TEXT("(%P|%t) INFO: UpdateProcessor::UpdateProcessor()\n")
    ));
  }
}

template< class DataType>
UpdateProcessor< DataType>::~UpdateProcessor(void)
{
  if( ::OpenDDS::DCPS::DCPS_debug_level > 0) {
    ACE_DEBUG((LM_DEBUG,
      ACE_TEXT("(%P|%t) INFO: UpdateProcessor::~UpdateProcessor()\n")
    ));
  }
}

template< class DataType>
void
UpdateProcessor< DataType>::processSample(
  const DataType*          sample,
  const ::DDS::SampleInfo* info
)
{
  if( ::OpenDDS::DCPS::DCPS_debug_level > 0) {
    ACE_DEBUG((LM_DEBUG,
      ACE_TEXT("(%P|%t) INFO: UpdateProcessor::processSample()\n")
    ));
  }
  if( info->valid_data) {
    switch( sample->action) {
      case CreateEntity:  this->processCreate( sample, info); break;
      case UpdateValue:   this->processUpdate( sample, info); break;
      case DestroyEntity: this->processDelete( sample, info); break;
      default:
        ACE_ERROR((LM_ERROR,
          ACE_TEXT("(%P|%t) ERROR: UpdateProcessor::processSample() - ")
          ACE_TEXT("upsupported action type: %d.\n"),
          sample->action
        ));
        break;
    }
  } else {
    if( ::OpenDDS::DCPS::DCPS_debug_level > 0) {
      ACE_DEBUG((LM_DEBUG,
        ACE_TEXT("(%P|%t) INFO: UpdateProcessor::processSample() - ")
        ACE_TEXT("sample not valid, declining to process.\n")
      ));
    }
  }
}

}} // End namespace OpenDDS::Federator

#endif /* UPDATEPROCESSOR__T_CPP */

