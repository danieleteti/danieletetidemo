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
			//zmq.Bind("E","MyQueue","","");

            int c = 0;
			while (true)
			{
                c++;
                byte[] message;
                int type;
				zmq.Receive(out message,out type, true);
				Console.WriteLine("#{2}.Readed '{0}' type {1}", ByteArrayToStr(message), type, c);
				Thread.Sleep(0);				
			}
		}
	}
}
