using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Collections;

/// <summary>
/// QueryString의 요약 설명입니다.
/// </summary>
/// 
namespace AppCommon
{
	public class QueryString
	{
        private SimpleDictionary datas;
		//private Hashtable datas;
		public QueryString()
		{
			//
			// TODO: 생성자 논리를 여기에 추가합니다.
			//
			datas = new SimpleDictionary();
		}

		public void Add(string key, string value)
		{
			datas.Add(key, value);
		}

		public void Clear()
		{
			datas.Clear();
		}

		public void Remove(string key)
		{
			datas.Remove(key);
		}

		public string GetValue(string key)
		{
			return (string)datas[key];
		}

		public int Count
		{
			get { return datas.Count; }
		}

        public SimpleDictionary Data
        {
            get { return datas; }
        }

		public string this[string key]
		{
			get { return (string)datas[key];  }
			set { datas[key] = value; }
		}

        public string GetQueryString()
        {
            string query_string = "";

            foreach (object obj in datas.Keys)
            {
                string key = (string)obj;
                if (query_string == "")
                {
                    query_string += key + "=" + (string)datas[key];
                }
                else
                {
                    query_string += "&" + key + "=" + (string)datas[key];
                }
            }
            return query_string;
        }
        public string GetQueryString(string exclude_key_list)
        {
			string[] list = exclude_key_list.Split(',');
			string query_string = "";

			foreach(object obj in datas.Keys)
			{
				string key = (string)obj;
				bool bExclude = false;
				foreach(string exclude in list) {
					if(key == exclude) {
						bExclude = true;
					}
				}
				if(!bExclude) {
					if(query_string == "") {
						query_string += key + "=" + (string)datas[key];
					} else {
						query_string += "&" + key + "=" + (string)datas[key];
					}
				}
			}
			return query_string;
		}

		public void SetQueryString(string query_string) 
		{
			string[] list = query_string.Split('&');
			datas.Clear();
			foreach(string str in list) {
				try
				{
					string[] key_value = str.Split('=');
					datas.Add(key_value[0], key_value[1]);
				}
				catch(Exception ex)
				{
					datas.Add(str, "");
				}
			}
		}

		public void AddQueryString(string query_string)
		{
			string[] list = query_string.Split('&');
			foreach (string str in list)
			{
				try
				{
					string[] key_value = str.Split('=');
					datas.Add(key_value[0], key_value[1]);
				}
				catch(Exception ex)
				{
					datas.Add(str, "");
				}
			}
		}
	}
}
