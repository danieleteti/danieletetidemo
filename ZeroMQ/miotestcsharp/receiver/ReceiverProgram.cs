using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;

namespace receiver
{
	class ReceiverProgram
	{
		static string ByteArrayToStr(byte[] str)
		{
			System.Text.ASCIIEncoding encoding = new System.Text.ASCIIEncoding();
			return encoding.GetString(str);
		}

	
		static void Main(string[] args)
		{
			Zmq zmq = new Zmq("localhost");			
			zmq.CreateQueue("MyQueue", Zmq.SCOPE_GLOBAL, "*", Zmq.NO_LIMIT,Zmq.NO_LIMIT,Zmq.NO_SWAP);
			zmq.Bind("E","MyQueue","","");
			
			while (true)
			{	
				byte[] barray = null;
				int atype;
				zmq.Receive(out barray,out atype, false);
				Console.WriteLine("Readed {0}", ByteArrayToStr(barray));
				Thread.Sleep(1000);				
			}
		}
	}
}
