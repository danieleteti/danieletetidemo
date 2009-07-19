using System;
using System.Runtime.InteropServices;

namespace zmq
{

    public class Dnzmq : IDisposable
    {
        private bool isDisposed = false;
        private IntPtr zmq_;

        public const int SCOPE_LOCAL = 0;
        public const int SCOPE_GLOBAL = 1;

        public Dnzmq()
        {
            zmq_ = IntPtr.Zero;
        }

        public Dnzmq(string host)
        {
            Open(host);
        }

        ~Dnzmq()
        {
            Dispose(false);
        }

        public void Open(string host)
        {
            zmq_ = czmq_create(host);
        }

        public bool IsOpen { get { return zmq_ == IntPtr.Zero; } }

        public int CreateExchange(string exchange, int scope, string nic)
        {
            if (zmq_ == IntPtr.Zero)
                throw new NullReferenceException("queue must be initialized");
            return czmq_create_exchange(zmq_, exchange, scope, nic);
        }

        public int CreateQueue(string queue, int scope, string nic, Int64 hwm, Int64 lwm, Int64 swapSize)
        {
            if (zmq_ == IntPtr.Zero)
                throw new NullReferenceException("queue must be initialized");
            return czmq_create_queue(zmq_, queue, scope, nic, hwm, lwm, swapSize);
        }

        public void Bind(string exchange, string queue, string exchangeArgs, string queueArgs)
        {
            if (zmq_ == IntPtr.Zero)
                throw new NullReferenceException("queue must be initialized");
            czmq_bind(zmq_, exchange, queue, exchangeArgs, queueArgs);
        }

        public void Send(int eid, byte[] data)
        {
            if (zmq_ == IntPtr.Zero)
                throw new NullReferenceException("queue must be initialized");
            IntPtr ptr = Marshal.AllocHGlobal(data.Length);
            Marshal.Copy(data, 0, ptr, data.Length);
            czmq_send(zmq_, eid, ptr, Convert.ToUInt32(data.Length), Free);
        }

        public int Receive(out byte[] data)
        {
            if (zmq_ == IntPtr.Zero)
                throw new NullReferenceException("queue must be initialized");
            IntPtr ptr;
            UInt32 dataSize;
            FreeMsgData freeFunc;
            int qid = 1; czmq_receive(zmq_, out ptr, out dataSize, out freeFunc);

            if (ptr == IntPtr.Zero) {
                data = null;
                return qid;
            }

            data = new byte[dataSize];
            Marshal.Copy(ptr, data, 0, Convert.ToInt32(dataSize));
            if (freeFunc != null)
                freeFunc(ptr);
            return qid;
        }

        private delegate void FreeMsgData(IntPtr ptr);

	public static void Free(IntPtr ptr)
        {
            Marshal.FreeHGlobal(ptr);
        }

        public void Close()
        {
            if (zmq_ != IntPtr.Zero)
            {
                czmq_destroy(zmq_);
                zmq_ = IntPtr.Zero;
            }
        }

        #region IDisposable Members

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(bool disposing)
        {
            if (!isDisposed)
            {
                if (disposing)
                {
                    // dispose managed resources
                }
                Close();
                isDisposed = true;
            }
        }

        #endregion

        #region C API

        [DllImport("libczmq", CharSet=CharSet.Ansi)]
        static extern IntPtr czmq_create(string host);

        [DllImport("libczmq")]
        static extern void czmq_destroy(IntPtr zmq);

        [DllImport("libczmq", CharSet=CharSet.Ansi)]
        static extern int czmq_create_exchange(IntPtr zmq, string exchange, int scope, string nic);

        [DllImport("libczmq", CharSet=CharSet.Ansi)]
        static extern int czmq_create_queue(IntPtr zmq, string queue, int scope, string nic,
            Int64 hwm, Int64 lwm, Int64 swapSize);

        [DllImport("libczmq", CharSet=CharSet.Ansi)]
        static extern void czmq_bind(IntPtr zmq, string exchange, string queue,
            string exchangeArgs, string queueArgs);

        [DllImport("libczmq")]
        static extern void czmq_send(IntPtr zmq, int eid, IntPtr data_, UInt32 size, FreeMsgData ffn);

        [DllImport("libczmq")]
        static extern void czmq_receive(IntPtr zmq, [Out] out IntPtr data, [Out] out UInt32 size,
            [Out] out FreeMsgData ffn);

        #endregion
    }
}
