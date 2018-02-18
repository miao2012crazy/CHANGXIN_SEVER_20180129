using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;

/// <summary>
/// RSAUtil 的摘要说明
/// </summary>
public static class RSAUtil
{

    public static string PUBLICKEY = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDu2ATZF3yX9/3y6YRo4XirzLo0
vYspSS3to/zr+5tONQQXpvBFeacdy4+tmw8jH37IMjB81Eu7liBCE6Om+DXaoz+R
n0vXxGvYxTSZO41odZtWDY0o68v3rlBABjAa+D91nLDlRJTC0Ks2jS4CHiLucQsU
SAQ391sRcddugovDzQIDAQAB";

    public static string PRIVATEKEY = @"MIICeQIBADANBgkqhkiG9w0BAQEFAASCAmMwggJfAgEAAoGBAO7YBNkXfJf3/fLp
hGjheKvMujS9iylJLe2j/Ov7m041BBem8EV5px3Lj62bDyMffsgyMHzUS7uWIEIT
o6b4NdqjP5GfS9fEa9jFNJk7jWh1m1YNjSjry/euUEAGMBr4P3WcsOVElMLQqzaN
LgIeIu5xCxRIBDf3WxFx126Ci8PNAgMBAAECgYEAoegZ0TgUo8fehC48LgS6Emvj
xiC/FyueULubljSnYOqbbZUix1XiLVZyfVLhfgO5o+gx6kzXUcBA+cnqZCNaDR60
yFfjTXfLktBd681pwvuAz2YmFm0I1ct+bk2vAudAmpb+fLgG/LPk0GJ+GZckXm3n
M7Ra37pFizrFYUUcZ9kCQQD/aCH3LsZ1cHVa7TNJcL0NwI1Pb/OG2d6ZvsS+BTYh
JArPrOZiXmvD5/BuMIeeFJK60jolYlR3cJYnDrtD3937AkEA72YJq4bkUisY8T3M
DyU67ZPvpQ/qzKlWVSnULvSNGb8JErAwZxVLVenSnLYSC0CtjDdkBTTOXj6mZJuF
1Zci1wJBAJoF0EXifWghM4Rr+zvUsw3yCsXW+4NdK/KHqtn1BpmhxKtM13qG+nIg
E0xAE+ju+zWSxeH5lHqa+NIA/kmGXbUCQQDFXluUlaaBc9Shd3BYADrAChol/KR4
zRdHKTAs8iOuWUhSpv2QzwaIMzkXSChCLLWoBzan8Cw/mOk3wtypBmyLAkEAvqym
g5359dRP74VzX/Xw6lr0ZoXCuw+2/5vI0UKz0Zsi+lyWRKRKFAIXJVulwMUN8ndn
591J4Dp4/Fkq/X4Xjg==";


    /// <summary>
    /// 生成密钥
    /// <param name="PrivateKey">私钥</param>
    /// <param name="PublicKey">公钥</param>
    /// <param name="KeySize">密钥长度：512,1024,2048，4096，8192</param>
    /// </summary>
    public static void Generator(out string PrivateKey, out string PublicKey, int KeySize = 1024)
    {
        RSACryptoServiceProvider rsa = new RSACryptoServiceProvider(KeySize);
        PrivateKey = rsa.ToXmlString(true); //将RSA算法的私钥导出到字符串PrivateKey中 参数为true表示导出私钥 true 表示同时包含 RSA 公钥和私钥；false 表示仅包含公钥。
        PublicKey = rsa.ToXmlString(false); //将RSA算法的公钥导出到字符串PublicKey中 参数为false表示不导出私钥 true 表示同时包含 RSA 公钥和私钥；false 表示仅包含公钥。
    }
    /// <summary>
    /// RSA加密 将公钥导入到RSA对象中，准备加密
    /// </summary>
    /// <param name="PublicKey">公钥</param>
    /// <param name="encryptstring">待加密的字符串</param>
    public static string RSAEncrypt(string PublicKey, string encryptstring)
    {
        byte[] PlainTextBArray;
        byte[] CypherTextBArray;
        string Result;
        RSACryptoServiceProvider rsa = new RSACryptoServiceProvider();
        rsa.FromXmlString(PublicKey);
        PlainTextBArray = (new UnicodeEncoding()).GetBytes(encryptstring);
        CypherTextBArray = rsa.Encrypt(PlainTextBArray, false);
        Result = Convert.ToBase64String(CypherTextBArray);
        return Result;
    }
    /// <summary>
    /// RSA解密 将私钥导入RSA中，准备解密
    /// </summary>
    /// <param name="PrivateKey">私钥</param>
    /// <param name="decryptstring">待解密的字符串</param>
    public static string RSADecrypt(string decryptstring)
    {
        byte[] PlainTextBArray;
        byte[] DypherTextBArray;
        string Result;
        RSACryptoServiceProvider rsa = new RSACryptoServiceProvider();
        rsa.FromXmlString(PRIVATEKEY);
        PlainTextBArray = Convert.FromBase64String(decryptstring);
        DypherTextBArray = rsa.Decrypt(PlainTextBArray, false);
        Result = (new UnicodeEncoding()).GetString(DypherTextBArray);
        return Result;
    }




}