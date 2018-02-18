using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Web;

namespace AppCommon
{
    public class CryptoHelper
    {

        public static void RSAKey(string PrivateKeyPath, string PublicKeyPath)
        {
            try
            {
                RSACryptoServiceProvider provider = new RSACryptoServiceProvider();
                CreatePrivateKeyXML(PrivateKeyPath, provider.ToXmlString(true));
                CreatePublicKeyXML(PublicKeyPath, provider.ToXmlString(false));
            }
            catch (Exception exception)
            {
                throw exception;
            }
        }

        /// <summary>
        /// 创建公钥文件
        /// </summary>
        /// <param name="path"></param>
        /// <param name="publickey"></param>
        public static void CreatePublicKeyXML(string path, string publickey)
        {
            try
            {
                FileStream publickeyxml = new FileStream(path, FileMode.Create);
                StreamWriter sw = new StreamWriter(publickeyxml);
                sw.WriteLine(publickey);
                sw.Close();
                publickeyxml.Close();
            }
            catch
            {
                throw;
            }
        }
        /// <summary>
        /// 创建私钥文件
        /// </summary>
        /// <param name="path"></param>
        /// <param name="privatekey"></param>
        public static void CreatePrivateKeyXML(string path, string privatekey)
        {
            try
            {
                FileStream privatekeyxml = new FileStream(path, FileMode.Create);
                StreamWriter sw = new StreamWriter(privatekeyxml);
                sw.WriteLine(privatekey);
                sw.Close();
                privatekeyxml.Close();
            }
            catch
            {
                throw;
            }
        }
        /// <summary>
        /// 读取公钥
        /// </summary>
        /// <param name="path"></param>
        /// <returns></returns>
        public static string ReadPublicKey(string path)
        {
            StreamReader reader = new StreamReader(path);
            string publickey = reader.ReadToEnd();
            reader.Close();
            return publickey;
        }
        /// <summary>
        /// 读取私钥
        /// </summary>
        /// <param name="path"></param>
        /// <returns></returns>
        public static string ReadPrivateKey(string path)
        {
            StreamReader reader = new StreamReader(path);
            string privatekey = reader.ReadToEnd();
            reader.Close();
            return privatekey;
        }



        public static byte[] RSASignSHA1(byte[] data, string privateKey)
        {
            using (RSACryptoServiceProvider provider = new RSACryptoServiceProvider())
            {
                return RSASignSHA1(provider, data, privateKey);
            }
        }

        public static byte[] RSASignSHA1(RSACryptoServiceProvider provider, byte[] data, string privateKey)
        {
            provider.FromXmlString(privateKey);
            //return provider.SignHash(ComputeSHA1(data), "SHA1");
            SHA1 sh = new SHA1CryptoServiceProvider();
            byte[] signData = provider.SignData(data, sh);
            return signData;
            //return Convert.ToBase64String(signData);
        }

        public static bool RSAVerifySHA1(byte[] data, string publicKey, byte[] signature)
        {
            using (RSACryptoServiceProvider provider = new RSACryptoServiceProvider())
            {
                return RSAVerifySHA1(provider, data, publicKey, signature);
            }
        }

        public static bool RSAVerifySHA1(RSACryptoServiceProvider provider, byte[] data, string publicKey, byte[] signature)
        {
            provider.FromXmlString(publicKey);
            //return provider.VerifyHash(ComputeSHA1(data), "SHA1", signature);
            SHA1 sh = new SHA1CryptoServiceProvider();
            return provider.VerifyData(data, sh, signature);
        }
        public static byte[] RSASignMD5(byte[] data, string privateKey)
        {
            using (RSACryptoServiceProvider provider = new RSACryptoServiceProvider())
            {
                return RSASignMD5(provider, data, privateKey);
            }
        }
        public static byte[] RSASignMD5(RSACryptoServiceProvider provider, byte[] data, string privateKey)
        {
            provider.FromXmlString(privateKey);
            return provider.SignHash(ComputeMD5(data), "MD5");
        }
        public static bool RSAVerifyMD5(byte[] data, string publicKey, byte[] signature)
        {
            using (RSACryptoServiceProvider provider = new RSACryptoServiceProvider())
            {
                return RSAVerifyMD5(provider, data, publicKey, signature);
            }
        }
        public static bool RSAVerifyMD5(RSACryptoServiceProvider provider, byte[] data, string publicKey, byte[] signature)
        {
            provider.FromXmlString(publicKey);
            return provider.VerifyHash(ComputeMD5(data), "MD5", signature);
        }
        public static byte[] RSAEncrypt(byte[] data, string publicKey, bool DoOAEPPadding)
        {
            using (RSACryptoServiceProvider provider = new RSACryptoServiceProvider())
            {
                return RSAEncrypt(provider, data, publicKey, DoOAEPPadding);
            }
        }
        public static byte[] RSAEncrypt(RSACryptoServiceProvider provider, byte[] data, string publicKey, bool DoOAEPPadding)
        {
            provider.FromXmlString(publicKey);
            return provider.Encrypt(data, DoOAEPPadding);
        }
        public static byte[] RSADecrypt(byte[] data, string privateKey, bool DoOAEPPadding)
        {
            CspParameters RSAParams = new CspParameters { Flags = CspProviderFlags.UseMachineKeyStore };

            //using (RSACryptoServiceProvider provider = new RSACryptoServiceProvider())
            using (RSACryptoServiceProvider provider = new RSACryptoServiceProvider(1024, RSAParams))
            {
                return RSADecrypt(provider, data, privateKey, DoOAEPPadding);
            }
        }
        public static byte[] RSADecrypt(RSACryptoServiceProvider provider, byte[] data, string privateKey, bool DoOAEPPadding)
        {
            provider.FromXmlString(privateKey);
            return provider.Decrypt(data, DoOAEPPadding);
        }
        public static byte[] TripleDESDecrypt(byte[] data, byte[] Key, byte[] IV)
        {
            using (TripleDESCryptoServiceProvider des = new TripleDESCryptoServiceProvider { Key = Key, IV = IV })
            {
                return des.CreateDecryptor().TransformFinalBlock(data, 0, data.Length);
            }
        }
        public static byte[] TripleDESDecrypt(string text, string HexStringKey, string HexStringIV)
        {
            return TripleDESDecrypt(HexStringToBytesArray(text), HexStringToBytesArray(HexStringKey), HexStringToBytesArray(HexStringIV));
        }
        public static byte[] TripleDESDecrypt(string text, byte[] Key, byte[] IV)
        {
            return TripleDESDecrypt(HexStringToBytesArray(text), Key, IV);
        }
        public static string TripleDESDecrypt(string text, string HexStringKey, string HexStringIV, Encoding e /*原文的encoding*/)
        {
            return e.GetString(TripleDESDecrypt(text, HexStringKey, HexStringIV));
        }
        public static string TripleDESDecrypt(string text, byte[] Key, byte[] IV, Encoding e /*原文的encoding*/)
        {
            return e.GetString(TripleDESDecrypt(text, Key, IV));
        }
        public static string GenerateTripleDESHexStringKey()
        {
            using (TripleDESCryptoServiceProvider des = new TripleDESCryptoServiceProvider())
            {
                des.GenerateKey();
                return BytesArrayToHexString(des.Key);
            }
        }
        public static string GenerateTripleDESHexStringIV()
        {
            using (TripleDESCryptoServiceProvider des = new TripleDESCryptoServiceProvider())
            {
                des.GenerateIV();
                return BytesArrayToHexString(des.IV);
            }
        }
        public static byte[] TripleDESEncrypt(byte[] data, byte[] Key, byte[] IV)
        {
            using (TripleDESCryptoServiceProvider des = new TripleDESCryptoServiceProvider { Key = Key, IV = IV })
            {
                return des.CreateEncryptor().TransformFinalBlock(data, 0, data.Length);
            }
        }
        public static byte[] TripleDESEncrypt(string text, Encoding e, byte[] Key, byte[] IV)
        {
            return TripleDESEncrypt(e.GetBytes(text), Key, IV);
        }
        public static byte[] TripleDESEncrypt(string text, Encoding e, string HexStringKey, string HexStringIV)
        {
            return TripleDESEncrypt(text, e, HexStringToBytesArray(HexStringKey), HexStringToBytesArray(HexStringIV));
        }
        public static byte[] ComputeSHA1(byte[] data)
        {
            return new SHA1CryptoServiceProvider().ComputeHash(data);
        }
        public static byte[] ComputeSHA1(string text, Encoding e)
        {
            return ComputeSHA1(e.GetBytes(text));
        }
        public static byte[] ComputeSHA1(string text)
        {
            return ComputeSHA1(text, Encoding.UTF8);
        }
        public static byte[] ComputeSHA1(Stream stream)
        {
            return new SHA1CryptoServiceProvider().ComputeHash(stream);
        }

        public static byte[] ComputeMD5(byte[] data)
        {
            return new MD5CryptoServiceProvider().ComputeHash(data, 0, data.Length);
        }

        public static byte[] ComputeMD5(string text, Encoding e)
        {
            return ComputeMD5(e.GetBytes(text));
        }

        public static byte[] ComputeMD5(string text)
        {
            return ComputeMD5(text, Encoding.UTF8);
        }

        public static byte[] ComputeMD5(Stream stream)
        {
            return new MD5CryptoServiceProvider().ComputeHash(stream);
        }

        public static string BytesArrayToHexString(byte[] data)
        {
            return BitConverter.ToString(data).Replace("-", "");
        }

        public static byte[] HexStringToBytesArray(string text)
        {
            text = text.Replace(" ", "");
            int l = text.Length;
            byte[] buffer = new byte[l / 2];
            for (int i = 0; i < l; i += 2)
            {
                buffer[i / 2] = Convert.ToByte(text.Substring(i, 2), 16);
            }
            return buffer;
        }
        /// <summary> 
        /// MD5 16位加密 
        /// 王启星
        /// 2009/9/29
        /// </summary> 
        /// <param name="ConvertString"></param> 
        /// <returns></returns> 
        public static string EncryptMD516(string _EncryptString)
        {
            using (MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider())
            {
                string t2 = BitConverter.ToString(md5.ComputeHash(UTF8Encoding.Default.GetBytes(_EncryptString)), 4, 8).ToLower();
                t2 = t2.Replace("-", "");
                return t2;
            }
        }
        /// <summary> 
        /// MD5 32位加密 
        /// 王启星
        /// 2009/9/29
        /// </summary> 
        /// <param name="str"></param> 
        /// <returns></returns> 
        public static string EncryptMD532(string _EncryptString)
        {
            string cl = _EncryptString;
            string pwd = "";
            MD5 md5 = MD5.Create();//实例化一个md5对像 
            // 加密后是一个字节类型的数组，这里要注意编码UTF8/Unicode等的选择　 
            byte[] s = md5.ComputeHash(Encoding.UTF8.GetBytes(cl));
            // 通过使用循环，将字节类型的数组转换为字符串，此字符串是常规字符格式化所得 
            for (int i = 0; i < s.Length; i++)
            {
                // 将得到的字符串使用十六进制类型格式。格式后的字符是小写的字母，如果使用大写（X）则格式后的字符是大写字符 

                pwd = pwd + s[i].ToString("X2");

            }

            return pwd;
        }


        /// <summary>
        /// md5Base64加密
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        //public static string Md5Base64(string str)
        //{
        //    MD5 md5 = MD5CryptoServiceProvider.Create();

        //    byte[] md5ed = md5.ComputeHash(System.Text.Encoding.GetEncoding("GBK").GetBytes(HttpUtility.UrlEncode(str)));

        //    return HttpUtility.UrlEncode(Convert.ToBase64String(md5ed, 0, md5ed.Length));
        //}
    }
}
