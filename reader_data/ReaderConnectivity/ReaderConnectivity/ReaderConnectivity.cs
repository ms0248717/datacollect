// Copyright ©2017-2018 Impinj, Inc.All rights reserved.
// You may use and modify this code under the terms of the Impinj Software Tools License & Disclaimer.
// Visit the following link for full license details, or contact Impinj, Inc. for a copy of the Impinj Software Tools License & Disclaimer.
//     https://support.impinj.com/hc/en-us/articles/360000468370-Software-Tools-License-Disclaimer

////////////////////////////////////////////////////////////////////////////////
//
//    Reader Connectivity example
//
////////////////////////////////////////////////////////////////////////////////

using System;
using System.IO;
using System.Data;
using System.Collections.Generic;
using Impinj.OctaneSdk;

namespace OctaneSdkUseCases
{
    class Program
    {
        public static DataTable table = new DataTable("TagTable");
        DataColumn column;
        DataRow row;

        // Create new DataColumn, set DataType, ColumnName
        // and add to DataTable.    
        const string READER_HOSTNAME = "192.168.1.91";  // NEED to set to your speedway!
        // Create an instance of the ImpinjReader class.
        static ImpinjReader reader = new ImpinjReader();
        //public DataTable table = new DataTable("TagTable");
        const string fullpath = @"..\..\..\..\data\circle_30_150_20.csv";

        static void ConnectToReader()
        {
            try
            {
                Console.WriteLine("Attempting to connect to {0} ({1}).",
                    reader.Name, READER_HOSTNAME); 
                
                // The maximum number of connection attempts
                // before throwing an exception.
                reader.MaxConnectionAttempts = 15;
                // Number of milliseconds before a 
                // connection attempt times out.
                reader.ConnectTimeout = 6000;
                // Connect to the reader.
                // Change the ReaderHostname constant in SolutionConstants.cs 
                // to the IP address or hostname of your reader.
                reader.Connect(READER_HOSTNAME);
                Console.WriteLine("Successfully connected.");

                // Tell the reader to send us any tag reports and 
                // events we missed while we were disconnected.
                reader.ResumeEventsAndReports();
            }
            catch (OctaneSdkException e)
            {
                Console.WriteLine("Failed to connect."); 
                throw e;
            }
        }
        public static void MakeDataTable()
        {
            // Create new DataColumn, set DataType, ColumnName
            // and add to DataTable.    

            table.Columns.Add("EPC", typeof(String));
            table.Columns.Add("Timestamp", typeof(String));
            table.Columns.Add("ChannelInMhz", typeof(Double));
            table.Columns.Add("PeakRssiInDbm", typeof(Double));
            table.Columns.Add("PhaseAngleInRadians", typeof(Double));


        }
        public static bool SaveCSV(DataTable dt, string fullPath)
        {
            try
            {
                FileInfo fi = new FileInfo(fullPath);
                if (!fi.Directory.Exists)
                {
                    fi.Directory.Create();
                }
                FileStream fs = new FileStream(fullPath, System.IO.FileMode.Create, System.IO.FileAccess.Write);
                //StreamWriter sw = new StreamWriter(fs, System.Text.Encoding.Default);
                StreamWriter sw = new StreamWriter(fs, System.Text.Encoding.UTF8);
                string data = "";
                //寫出列名稱
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    data += "\"" + dt.Columns[i].ColumnName.ToString() + "\"";
                    if (i < dt.Columns.Count - 1)
                    {
                        data += ",";
                    }
                }
                sw.WriteLine(data);
                
                //寫出各行數據
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    data = "";
                    for (int j = 0; j < dt.Columns.Count; j++)
                    {
                        string str = dt.Rows[i][j].ToString();
                        str = string.Format("\"{0}\"", str);
                        data += str;
                        if (j < dt.Columns.Count - 1)
                        {
                            data += ",";
                        }
                    }
                    sw.WriteLine(data);
                }
                sw.Close();
                fs.Close();
                return true;
            }
            catch
            {
                return false;
            }
        }

        static void Main(string[] args)
        {
            try
            {
                // Assign a name to the reader. 
                // This will be used in tag reports. 
                reader.Name = "My Reader #1";
                MakeDataTable();
                // Connect to the reader.
                ConnectToReader();

                // Get the default settings.
                // We'll use these as a starting point
                // and then modify the settings we're 
                // interested in.
                Settings settings = reader.QueryDefaultSettings();

                // Start the reader as soon as it's configured.
                // This will allow it to run without a client connected.
                settings.AutoStart.Mode = AutoStartMode.Immediate;
                settings.AutoStop.Mode = AutoStopMode.None;

                // Use Advanced GPO to set GPO #1 
                // when an client (LLRP) connection is present.
                settings.Gpos.GetGpo(1).Mode = GpoMode.LLRPConnectionStatus;

                // settings readermode
                settings.ReaderMode = ReaderMode.DenseReaderM4;

                // Tell the reader to include the timestamp in all tag reports.
                settings.Report.IncludeFirstSeenTime = true;
                settings.Report.IncludeLastSeenTime = true;
                settings.Report.IncludeSeenCount = true;
                settings.Report.IncludePhaseAngle = true;
                settings.Report.IncludePeakRssi = true;
                settings.Report.IncludeChannel = true;
                settings.Report.IncludeDopplerFrequency = true;
                settings.Report.IncludeFastId = true;
                settings.Report.IncludeGpsCoordinates = true;

                //settings.Report.

                //setting freq
                /*List<double> freqList = new List<double>();
                freqList.Add(923.25);
                freqList.Add(924.25);
                settings.TxFrequenciesInMhz = freqList;
                */
                // If this application disconnects from the 
                // reader, hold all tag reports and events.
                settings.HoldReportsOnDisconnect = true;

                // Enable keepalives.
                settings.Keepalives.Enabled = true;
                settings.Keepalives.PeriodInMs = 5000;

                // Enable link monitor mode.
                // If our application fails to reply to
                // five consecutive keepalive messages,
                // the reader will close the network connection.
                settings.Keepalives.EnableLinkMonitorMode = true;
                settings.Keepalives.LinkDownThreshold = 5;

                // Assign an event handler that will be called
                // when keepalive messages are received.
                reader.KeepaliveReceived += OnKeepaliveReceived;

                // Assign an event handler that will be called
                // if the reader stops sending keepalives.
                reader.ConnectionLost += OnConnectionLost;

                // Apply the newly modified settings.
                reader.ApplySettings(settings);

                // Save the settings to the reader's 
                // non-volatile memory. This will
                // allow the settings to persist
                // through a power cycle.
                reader.SaveSettings();

                // Assign the TagsReported event handler.
                // This specifies which method to call
                // when tags reports are available.
                reader.TagsReported += OnTagsReported;

                // Wait for the user to press enter.
                Console.WriteLine("Press enter to exit.");
                //Console.ReadLine();
                System.Threading.Thread.Sleep(8000);
                // Save Data
                SaveCSV(table, fullpath);
                
                // Stop reading.
                reader.Stop();

                // Disconnect from the reader.
                reader.Disconnect();
            }
            catch (OctaneSdkException e)
            {
                // Handle Octane SDK errors.
                Console.WriteLine("Octane SDK exception: {0}", e.Message);
            }
            catch (Exception e)
            {
                // Handle other .NET errors.
                Console.WriteLine("Exception : {0}", e.Message);
            }
        }

        static void OnConnectionLost(ImpinjReader reader)
        {
            // This event handler is called if the reader  
            // stops sending keepalive messages (connection lost).
            Console.WriteLine("Connection lost : {0} ({1})", reader.Name, reader.Address);

            // Cleanup
            reader.Disconnect();

            // Try reconnecting to the reader
            ConnectToReader();
        }

        static void OnKeepaliveReceived(ImpinjReader reader)
        {
            // This event handler is called when a keepalive 
            // message is received from the reader.
            Console.WriteLine("Keepalive received from {0} ({1})", reader.Name, reader.Address);
        }

        static void OnTagsReported(ImpinjReader sender, TagReport report)
        {
            // This event handler is called asynchronously 
            // when tag reports are available.
            // Loop through each tag in the report 
            // and print the data.
            DataRow workRow = table.NewRow();
            foreach (Tag tag in report)
            {
                /*if (tag.Epc.ToString() == "E200 9366 C6B6 7BF1 9071 BDEF")
                {
                    Console.WriteLine("EPC : {0} Timestamp : {1}", tag.Epc, tag.LastSeenTime);
                    //Console.WriteLine("RfDopplerFrequency : {0} ChannelInMhz : {1}", tag.RfDopplerFrequency, tag.ChannelInMhz);
                    Console.WriteLine("PeakRssiInDbm : {0} PhaseAngleInRadians : {1}", tag.PeakRssiInDbm, tag.PhaseAngleInRadians);
                }*/
                Console.WriteLine("EPC : {0} Timestamp : {1}", tag.Epc, tag.LastSeenTime);
                //Console.WriteLine("RfDopplerFrequency : {0} ChannelInMhz : {1}", tag.RfDopplerFrequency, tag.ChannelInMhz);
                Console.WriteLine("PeakRssiInDbm : {0} PhaseAngleInRadians : {1}", tag.PeakRssiInDbm, tag.PhaseAngleInRadians);
                workRow["EPC"] = tag.Epc;
                workRow["Timestamp"] = tag.LastSeenTime;
                workRow["ChannelInMhz"] = tag.ChannelInMhz;
                workRow["PeakRssiInDbm"] = tag.PeakRssiInDbm;
                workRow["PhaseAngleInRadians"] = tag.PhaseAngleInRadians;
                table.Rows.Add(workRow);
            }
        }
    }
}
