using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;

namespace ConsoleApplication1
{
	class SenderProgram
	{
		static byte[] StrToByteArray(string str)
		{
			System.Text.ASCIIEncoding encoding = new System.Text.ASCIIEncoding();
			return encoding.GetBytes(str);
		}
		
		static void Main(string[] args)
		{
			Zmq zmq = new Zmq("localhost");
            int ex = zmq.CreateExchange("E", Zmq.SCOPE_LOCAL, "", Zmq.STYLE_LOAD_BALANCING);
            zmq.Bind("E", "MyQueue", null, null);
			int i = 1;		
			while (true)
			{
				string data = "Hello World";
				Console.WriteLine("#{1}. sending '{0}'",data,i);
				zmq.Send(ex, StrToByteArray(data), false);
				Thread.Sleep(1);
				i++;
			}
		}
	}
}
