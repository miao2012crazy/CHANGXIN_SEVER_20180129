using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// TimeUtils 的摘要说明
/// </summary>
public static class TimeUtils
{
    /// <summary>
    /// 获取当前时间的时间戳
    /// </summary>
    /// <returns></returns>
    public static string getTimeStamp(DateTime dt)
    {
        TimeSpan ts = dt.ToUniversalTime() - new DateTime(1970, 1, 1, 0, 0, 0, 0);
        return Convert.ToInt64(ts.TotalSeconds).ToString();
    }

    /// <summary>
    /// 获取当前时间的时间戳
    /// </summary>
    /// <returns></returns>
    public static long getTimeStampForLong(DateTime dt)
    {
        TimeSpan ts = dt.ToUniversalTime() - new DateTime(1970, 1, 1, 0, 0, 0, 0);
        return Convert.ToInt64(ts.TotalSeconds);
    }


    /// <summary>
    /// 获取当前周的周日 23:59:59
    /// </summary>
    /// <returns></returns>
    public static string GetWeekLastDaySat()
    {
        DateTime dt = DateTime.Now;
        //星期六为最后一天  
        int weeknow = Convert.ToInt32(dt.DayOfWeek);
        int daydiff = (7 - weeknow) + 1;
        string LastDay = dt.AddDays(daydiff).ToString("yyyy-MM-dd");
        DateTime dt_final = Convert.ToDateTime(LastDay);
        return getTimeStamp(dt_final);
    }

    public static string GetWeekNextDaySat()
    {
        DateTime dt = DateTime.Now;
        //星期六为最后一天  
        int weeknow = Convert.ToInt32(dt.DayOfWeek);
        int daydiff = (7 - weeknow) + 8;
        string LastDay = dt.AddDays(daydiff).ToString("yyyy-MM-dd");
        DateTime dt_final = Convert.ToDateTime(LastDay);
        return getTimeStamp(dt_final);
    }


    /// <summary>
    /// 当前是本年的第几周
    /// </summary>
    /// <param name="day">日期</param>
    /// <returns></returns>
    public static string WeekOfYear(DateTime day)
    {
        int weeknum;
        System.DateTime fDt = DateTime.Parse(day.Year.ToString() + "-01-01");
        int k = Convert.ToInt32(fDt.DayOfWeek);//得到该年的第一天是周几 
        if (k == 0)
        {
            k = 7;
        }
        int l = Convert.ToInt32(day.DayOfYear);//得到当天是该年的第几天 
        l = l - (7 - k + 1);
        if (l <= 0)
        {
            weeknum = 1;
        }
        else
        {
            if (l % 7 == 0)
            {
                weeknum = l / 7 + 1;
            }
            else
            {
                weeknum = l / 7 + 2;//不能整除的时候要加上前面的一周和后面的一周 
            }
        }
        if (weeknum.ToString().Length == 1)
        {
            return day.Year.ToString() + "0" + weeknum;
        }
        else
        {
            return day.Year.ToString() + weeknum;
        }
    }
    /// <summary>
    /// 某月第一天所在周 
    /// </summary>
    /// <returns></returns>
    public static string getQuarterStart(DateTime dt)
    {
        //本月第一天
        DateTime d1 = new DateTime(dt.Year, dt.Month, 1);
        ////本月最后一天
        //DateTime d2 = d1.AddMonths(1).AddDays(-1);

        return WeekOfYear(d1);
    }








    /// <summary>
    /// 某月最后一天所在周 
    /// </summary>
    /// <returns></returns>
    public static string getQuarterEnd(DateTime dt)
    {
        //本月第一天
        DateTime d1 = new DateTime(dt.Year, dt.Month, 1);
        //本月最后一天
        DateTime d2 = d1.AddMonths(1).AddDays(-1);

        return WeekOfYear(d2);
    }

    /// <summary>
    /// 获取查询终止的日期 往前查14天 
    /// </summary>
    /// <returns></returns>
    public static DateTime getEndDate()
    {
        DateTime date = DateTime.Now.AddDays(-14);
        return date;
    }

    /// <summary>
    /// 获取查询终止的日期 往前查14天 
    /// </summary>
    /// <returns></returns>
    public static string getEndDateWeek()
    {
        DateTime date = DateTime.Now.AddDays(-14);
        return WeekOfYear(date);
    }

    /// <summary>
    /// 某月第一天所在月 用于 app 左侧栏查询季度月份
    /// 0 查询本月
    /// 1 查询前一个月
    /// 2 查询前两个月
    /// </summary>
    /// <returns></returns>
    public static string getMonth(int index)
    {
        DateTime date = DateTime.Now.AddDays(-14);
        switch (index)
        {
            case 0:
                return date.Year + "年" + date.Month;
            case 1:
                DateTime dt1 = date.AddMonths(-1);
                return dt1.Year + "年" + dt1.Month;
            case 2:
                DateTime dt2 = date.AddMonths(-2);
                return dt2.Year + "年" + dt2.Month;
            case 3:
                DateTime dt3 = date.AddMonths(-3);
                return dt3.Year + "年" + dt3.Month;
            case 4:
                DateTime dt4 = date.AddMonths(-4);
                return dt4.Year + "年" + dt4.Month;
            case 5:
                DateTime dt5 = date.AddMonths(-5);
                return dt5.Year + "年" + dt5.Month;
            default:
                return "";
        }

    }






}