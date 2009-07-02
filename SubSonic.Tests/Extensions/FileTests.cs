// 
//   SubSonic - http://subsonicproject.com
// 
//   The contents of this file are subject to the New BSD
//   License (the "License"); you may not use this file
//   except in compliance with the License. You may obtain a copy of
//   the License at http://www.opensource.org/licenses/bsd-license.php
//  
//   Software distributed under the License is distributed on an 
//   "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
//   implied. See the License for the specific language governing
//   rights and limitations under the License.
// 
using System;
using SubSonic.Extensions;
using Xunit;

namespace SubSonic.Tests.Extensions
{
    public class FileTests
    {
        private readonly string tempPath = Environment.GetEnvironmentVariable("TMP");

        [Fact]
        public void GetFileText_Should_Read_Text_From_Existing_File()
        {
            //save test text to file
            "this is a stupid test".CreateToFile(tempPath + "\\testfile.txt");

            //sorry for this test
            string fileText = (tempPath + "\\testfile.txt").GetFileText();
            //it's the only way I can think of to do it
            Assert.Equal(fileText, "this is a stupid test");
        }

        [Fact]
        public void CreateToFile_Should_SaveText_To_File()
        {
            //sorry for this test
            "this is a stupid test".CreateToFile(tempPath + "\\testfile2.txt");
            //it's the only way I can think of to do it
            Assert.Equal((tempPath + "\\testfile2.txt").GetFileText(), "this is a stupid test");
        }

        [Fact]
        public void UpdateFileText_Should_Replace_Existing_File_Text()
        {
            //sorry for this test
            "this is a stupid test".CreateToFile(tempPath + "\\testfile3.txt");

            (tempPath + "\\testfile3.txt").UpdateFileText("stupid", "really stupid");

            //it's the only way I can think of to do it
            Assert.Equal((tempPath + "\\testfile3.txt").GetFileText(), "this is a really stupid test");
        }

        [Fact]
        public void WriteToFile_Should_SaveText_To_File()
        {
            //sorry for this test
            "this is a stupid test".CreateToFile(tempPath + "\\testfile4.txt");
            //it's the only way I can think of to do it
            Assert.Equal((tempPath + "\\testfile4.txt").GetFileText(), "this is a stupid test");
        }
    }
}