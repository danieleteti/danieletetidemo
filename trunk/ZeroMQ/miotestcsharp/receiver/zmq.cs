using System;
using System.Runtime.InteropServices;


    public class Zmq : IDisposable
    {
        private bool isDisposed = false;
        private IntPtr transport;

        public const int SCOPE_LOCAL = 1;
        public const int SCOPE_PROCESS = 2;
        public const int SCOPE_GLOBAL = 3;

        public const int MESSAGE_DATA = 1;
        public const int MESSAGE_GAP = 2;

        public const int STYLE_DATA_DISTRIBUTION = 1;
        public const int STYLE_LOAD_BALANCING = 2;

        //  Defines watermark level.
        public const int NO_LIMIT = -1;

        public const int NO_SWAP = 0;

        public Zmq ()
        {
            transport = IntPtr.Zero;
        }

        public Zmq (string host)
        {
            Open (host);
        }

        ~Zmq ()
        {
            Dispose (false);
        }

        public void Open (string host)
        {
            transport = zmq_create (host);
        }
	
        public void Mask (int notifications)
        {
            zmq_mask (transport, Convert.ToUInt32 (notifications));
        }
	
        public int CreateExchange (string name, int scope, string location, 
            int style)
        {
            return zmq_create_exchange (transport, name, scope, location, 
                style);
        }

        public int CreateQueue (string name, int scope, string location, 
            Int64 hwm, Int64 lwm, Int64 swap)
        {
            return zmq_create_queue (transport, name, scope, location, hwm, lwm,
                swap);
        }

        public void Bind (string exchangeName, string queueName, 
            string exchangeArgs, string queueArgs)
        {
            zmq_bind (transport, exchangeName, queueName, exchangeArgs, 
                queueArgs);
        }

        public bool Send (int exchange, byte[] message, bool block)
        {
            IntPtr ptr = Marshal.AllocHGlobal (message.Length);
            Marshal.Copy (message, 0, ptr, message.Length);
		    int sent = zmq_send (transport, exchange, ptr,
                Convert.ToUInt64 (message.Length), Convert.ToInt32 (block));
		    
            Marshal.FreeHGlobal (ptr);

            return Convert.ToBoolean (sent);
            
        }
	
        public int Receive (out byte[] message, out int type, bool block)
        {
            IntPtr ptr;
            UInt64 messageSize;
            UInt32 typeOut;
		    		     
            int queue = zmq_receive (transport, out ptr, out messageSize,
		          out typeOut, Convert.ToInt32 (block));
		    type = (int) typeOut;

            if (ptr == IntPtr.Zero)
            {
                message = null;
                return queue;
            }

            message = new byte[messageSize];
            Marshal.Copy (ptr, message, 0, message.Length);
            zmq_free (ptr);

            return queue;
        }
                
        public void Destroy ()
        {
            if (transport != IntPtr.Zero)
            {
                zmq_destroy (transport);
                transport = IntPtr.Zero;
            }
        }

        #region IDisposable Members

        public void Dispose ()
        {
            Dispose (true);
            GC.SuppressFinalize (this);
        }

        protected virtual void Dispose (bool disposing)
        {
            if (!isDisposed)
            {
                if (disposing)
                {
                    // dispose managed resources
                }
                Destroy ();
                isDisposed = true;
            }
        }

        #endregion

        #region C API

        [DllImport ("libczmq", CharSet = CharSet.Ansi, 
            CallingConvention = CallingConvention.Cdecl)]
        static extern IntPtr zmq_create (string host);

        [DllImport ("libczmq", CallingConvention = CallingConvention.Cdecl)]
        static extern void zmq_destroy (IntPtr zmq);

        [DllImport ("libczmq", CallingConvention = CallingConvention.Cdecl)]
        static extern void zmq_mask (IntPtr zmq, UInt32 notifications);

        [DllImport ("libczmq", CharSet = CharSet.Ansi, CallingConvention = 
            CallingConvention.Cdecl)]
        static extern int zmq_create_exchange (IntPtr zmq, string name,
            int scope, string location, int style);

        [DllImport ("libczmq", CharSet = CharSet.Ansi, 
            CallingConvention = CallingConvention.Cdecl)]
        static extern int zmq_create_queue (IntPtr zmq, string name, int scope,
            string location, Int64 hwm, Int64 lwm, Int64 swap);

        [DllImport ("libczmq", CharSet = CharSet.Ansi, 
            CallingConvention = CallingConvention.Cdecl)]
        static extern void zmq_bind (IntPtr zmq, string exchange_name, 
            string queue_name, string exchange_options, string queue_options);

        [DllImport ("libczmq", CallingConvention = CallingConvention.Cdecl)]
        static extern int zmq_send (IntPtr zmq, int exchange, IntPtr data,
            UInt64 size, int block);

        [DllImport ("libczmq", CallingConvention = CallingConvention.Cdecl)]
        static extern int zmq_receive (IntPtr zmq, [Out] out IntPtr data,
             [Out] out UInt64 size, [Out] out UInt32 type, int block);

        [DllImport ("libczmq", CallingConvention = CallingConvention.Cdecl)]
        static extern void zmq_free (IntPtr data_);
	
        #endregion
    }
