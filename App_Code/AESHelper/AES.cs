﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;

/// <summary>
/// AES 的摘要说明
/// </summary>
namespace AppCommon
{
    public class AES
    {
        private static string iv = "9632587412365478"; //偏移量,可自行修改
        //public static string Encrypt(string toEncrypt, string key)
        //{
        //    byte[] keyArray = UTF8Encoding.UTF8.GetBytes(key);
        //    byte[] ivArray = UTF8Encoding.UTF8.GetBytes(iv);
        //    byte[] toEncryptArray = UTF8Encoding.UTF8.GetBytes(toEncrypt);

        //    RijndaelManaged rDel = new RijndaelManaged();
        //    rDel.BlockSize = 128;
        //    rDel.KeySize = 256;
        //    rDel.FeedbackSize = 128;
        //    rDel.Padding = PaddingMode.Zeros;
        //    rDel.Key = keyArray;
        //    rDel.IV = ivArray;
        //    rDel.Mode = CipherMode.CBC;
        //    ICryptoTransform cTransform = rDel.CreateEncryptor();
        //    byte[] resultArray = cTransform.TransformFinalBlock(toEncryptArray, 0, toEncryptArray.Length);

        //    return Convert.ToBase64String(resultArray, 0, resultArray.Length);
        //}
        
        //public static string Decrypt(string toDecrypt, string key)
        //{
        //    byte[] keyArray = UTF8Encoding.UTF8.GetBytes(key);
        //    byte[] ivArray = UTF8Encoding.UTF8.GetBytes(iv);
        //    byte[] toEncryptArray = Convert.FromBase64String(toDecrypt);

        //    // 这里的模式，请保持和上面加密的一样。但源代码里，这个地方并没有修正，虽然也能正确解密。看到博客的朋友，请自行修改。
        //    // 这是个人疏忽的地址，感谢@jojoka 的提醒。
        //    RijndaelManaged rDel = new RijndaelManaged();
        //    //rDel.Key = keyArray;
        //    //rDel.IV = ivArray;
        //    //rDel.Mode = CipherMode.CBC;
        //    //rDel.Padding = PaddingMode.Zeros;

        //    rDel.BlockSize = 128;
        //    rDel.KeySize = 256;
        //    rDel.FeedbackSize = 128;
        //    rDel.Padding = PaddingMode.Zeros;
        //    rDel.Key = keyArray;
        //    rDel.IV = ivArray;
        //    rDel.Mode = CipherMode.CBC;

        //    ICryptoTransform cTransform = rDel.CreateDecryptor();

        //    byte[] resultArray = cTransform.TransformFinalBlock(toEncryptArray, 0, toEncryptArray.Length);

        //    return UTF8Encoding.UTF8.GetString(resultArray);
        //}


        public static string Encrypt(string toEncrypt, string key, string iv_1)
        {
            byte[] keyArray = UTF8Encoding.UTF8.GetBytes(key);
            byte[] ivArray = UTF8Encoding.UTF8.GetBytes(iv);
            byte[] toEncryptArray = UTF8Encoding.UTF8.GetBytes(toEncrypt);

            RijndaelManaged rDel = new RijndaelManaged();
            rDel.Key = keyArray;
            rDel.IV = ivArray;
            rDel.Mode = CipherMode.CBC;
            rDel.Padding = PaddingMode.PKCS7;

            ICryptoTransform cTransform = rDel.CreateEncryptor();
            byte[] resultArray = cTransform.TransformFinalBlock(toEncryptArray, 0, toEncryptArray.Length);

            return Convert.ToBase64String(resultArray, 0, resultArray.Length);
        }

        public static string Decrypt(string toDecrypt, string key, string iv_1)
        {
            byte[] keyArray = UTF8Encoding.UTF8.GetBytes(key);
            byte[] ivArray = UTF8Encoding.UTF8.GetBytes(iv);
            byte[] toEncryptArray = Convert.FromBase64String(toDecrypt);

            RijndaelManaged rDel = new RijndaelManaged();
            rDel.Key = keyArray;
            rDel.IV = ivArray;
            rDel.Mode = CipherMode.CBC;
            rDel.Padding = PaddingMode.Zeros;

            ICryptoTransform cTransform = rDel.CreateDecryptor();
            byte[] resultArray = cTransform.TransformFinalBlock(toEncryptArray, 0, toEncryptArray.Length);

            return UTF8Encoding.UTF8.GetString(resultArray);
        }




    }

}