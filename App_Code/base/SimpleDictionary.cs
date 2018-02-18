using System;
using System.Collections;
using System.Runtime.Serialization;
//using System.Runtime.Serialization.Formatters.Soap;

/// <summary>
/// Dictionary의 요약 설명입니다.
/// </summary>
/// 
[Serializable()]
public class SimpleDictionary : DictionaryBase
{
	public SimpleDictionary()
	{
		//
		// TODO: 생성자 논리를 여기에 추가합니다.
		//
	}

    public string this[string key]
    {
        get { return (string)Dictionary[key]; }
        set { Dictionary[key] = value; }
    }

    public ICollection Keys
    {
        get { return (Dictionary.Keys); }
    }

    public ICollection Values
    {
        get { return (Dictionary.Values); }
    }

    public int Count
    {
        get { return (Dictionary.Count); }
    }

    public void Add(string key, string value)
    {
        Dictionary.Add(key, value);
    }

    public bool Contains(string key)
    {
        return (Dictionary.Contains(key));
    }

    public void Remove(string key)
    {
        Dictionary.Remove(key);
    }

    public void Clear()
    {
        Dictionary.Clear();
    }

}
