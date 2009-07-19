/*
    Copyright (c) 2007-2009 FastMQ Inc.

    This file is part of 0MQ.

    0MQ is free software; you can redistribute it and/or modify it under
    the terms of the Lesser GNU General Public License as published by
    the Free Software Foundation; either version 3 of the License, or
    (at your option) any later version.

    0MQ is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    Lesser GNU General Public License for more details.

    You should have received a copy of the Lesser GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <stddef.h>
#include <zmq/export.hpp>
#include <zmq/stdint.hpp>

#ifdef __cplusplus
extern "C" {
#endif

#define ZMQ_SCOPE_LOCAL 1
#define ZMQ_SCOPE_PROCESS 2
#define ZMQ_SCOPE_GLOBAL 3

#define ZMQ_MESSAGE_DATA 1
#define ZMQ_MESSAGE_GAP 2

#define ZMQ_STYLE_DATA_DISTRIBUTION 1
#define ZMQ_STYLE_LOAD_BALANCING 2

#define ZMQ_NO_LIMIT -1
#define ZMQ_NO_SWAP 0

#define ZMQ_TRUE 1
#define ZMQ_FALSE 0

void ZMQ_EXPORT *zmq_create (const char *host_);

void ZMQ_EXPORT zmq_destroy (void *object_);

void ZMQ_EXPORT zmq_mask (void *object_, uint32_t notifications_);

int ZMQ_EXPORT zmq_create_exchange (void *object_, const char *name_, 
    int scope_, const char *location_, int style_);

int ZMQ_EXPORT zmq_create_queue (void *object_, const char *name_, int scope_,
    const char *location_, int64_t hwm_, int64_t lwm_, int64_t swap_);

void ZMQ_EXPORT zmq_bind (void *object_, const char *exchange_name_, 
    const char *queue_name_, const char *exchange_options_, 
    const char *queue_options_);

int ZMQ_EXPORT zmq_send (void *object_, int exchange_, const void *data_,
    uint64_t size_, int block_);

int ZMQ_EXPORT zmq_receive (void *object_, void **data_, uint64_t *size_,
    uint32_t *type_, int block_);

void ZMQ_EXPORT zmq_free (void *data_);

#ifdef __cplusplus
}
#endif
