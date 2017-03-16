using HrmsMvc.Models;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Mvc;

namespace HrmsMvc
{
    public static class Db
    {
        #region Manage Employee and Authentication

        public static DataTable Validateuser(string userName, string password)
        {
            DataTable dt = new DataTable();
            //SqlDataAdapter da = new SqlDataAdapter("SELECT ID,UserName,Password,UserType FROM UserInfo WHERE UserName = @userName COLLATE SQL_Latin1_General_CP1_CS_AS and Password = @password COLLATE SQL_Latin1_General_CP1_CS_AS", ConfigurationManager.ConnectionStrings["hrmscon"].ConnectionString);
            SqlDataAdapter da = new SqlDataAdapter("SELECT ID,UserName,Password,UserType FROM UserInfo WHERE UserName = @userName COLLATE SQL_Latin1_General_CP1_CS_AS", ConfigurationManager.ConnectionStrings["hrmscon"].ConnectionString);

            da.SelectCommand.Parameters.AddWithValue("userName", userName);
            //da.SelectCommand.Parameters.AddWithValue("password", password);
            da.Fill(dt);

            if (dt != null && dt.Rows.Count > 0)
            {
                if (!Helpers.Helper.matchPassword(password, dt.Rows[0]["Password"].ToString()))
                {
                    dt = null;
                }
            }

            return dt;
        }

        public static DataTable GetEmployeeInfo(int EmpId, string empEmail = null)
        {
            DataTable dt = new DataTable();
            string SelQuery = "";
            SqlDataAdapter da = null;

            if (string.IsNullOrEmpty(empEmail))
            {
                SelQuery = "SELECT a.UserName,b.EmpName,c.Privilage AS UserRole,b.EmpGender,b.EmpPhone,b.EmpEmail,b.EmpDob,b.EmpPhotoPath,ed.Designation,b.EmpDesignation FROM EmployeeInfo b INNER JOIN UserInfo a ON a.ID = @EmpId INNER JOIN UserPrivilages c ON a.UserType=c.Id INNER JOIN EmpDesignation ed ON b.EmpDesignation = ed.ID WHERE b.EmpId = @EmpId";
                da = new SqlDataAdapter(SelQuery, ConfigurationManager.ConnectionStrings["hrmscon"].ConnectionString);
                da.SelectCommand.Parameters.AddWithValue("EmpId", EmpId);
            }
            else
            {
                SelQuery = "SELECT ei.EmpId,ei.EmpName,ei.EmpPhone,ei.EmpEmail FROM EmployeeInfo ei WHERE ei.EmpEmail = @empEmail";
                da = new SqlDataAdapter(SelQuery, ConfigurationManager.ConnectionStrings["hrmscon"].ConnectionString);
                da.SelectCommand.Parameters.AddWithValue("empEmail", empEmail);
            }

            da.Fill(dt);
            return dt;
        }

        public static string UpdateUserPassword(int empId, string currPwd = null, string nwPwd = null)
        {
            string rtrnStr = "";
            try
            {
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["hrmscon"].ConnectionString))
                {
                    con.Open();
                    SqlCommand cmd = null;
                    if (!string.IsNullOrEmpty(currPwd))
                    {
                        cmd = new SqlCommand("SELECT ID,Password FROM UserInfo WHERE ID = @EmpId", con);
                        cmd.Parameters.AddWithValue("EmpId", empId);

                        SqlDataReader sreader = cmd.ExecuteReader();

                        if (sreader.HasRows)
                        {
                            string stordPwd = "";
                            while (sreader.Read())
                            {
                                stordPwd = sreader["Password"].ToString();
                            }

                            sreader.Close();

                            if (Helpers.Helper.matchPassword(currPwd, stordPwd))
                            {
                                cmd = new SqlCommand("UPDATE UserInfo SET Password = @nwPwd WHERE ID = @EmpId", con);
                                cmd.Parameters.AddWithValue("EmpId", empId);
                                cmd.Parameters.AddWithValue("nwPwd", Helpers.Helper.HashPassword(nwPwd));

                                int rtrn = cmd.ExecuteNonQuery();
                                rtrnStr = (rtrn <= 0) ? "ERROR:" : "OK:";
                            }
                            else
                            {
                                rtrnStr = "PMM:";
                            }
                        }
                    }
                    else
                    {
                        cmd = new SqlCommand("UPDATE UserInfo SET Password = @nwPwd WHERE ID = @EmpId", con);
                        cmd.Parameters.AddWithValue("EmpId", empId);
                        cmd.Parameters.AddWithValue("nwPwd", Helpers.Helper.HashPassword(nwPwd));

                        int rtrn = cmd.ExecuteNonQuery();
                        rtrnStr = (rtrn <= 0) ? "ERROR:" : "OK:";
                    }
                    con.Close();
                }

                return rtrnStr;
            }
            catch (Exception ex)
            {
                return "ERROR";
            }
        }

        public static List<EmployeeModel> GetEmployeeDetails(int BlockSize, int BlockNumber)
        {
            int startIndex = (BlockNumber - 1) * BlockSize;

            DataTable dt = new DataTable();
            SqlDataReader sreader = null;
            int totalRows = 0;
            EmployeeModel em = null;
            List<EmployeeModel> empDetails = new List<EmployeeModel>();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["hrmscon"].ConnectionString))
            {
                con.Open();
                SqlCommand scmd = new SqlCommand("SELECT COUNT(ID) FROM UserInfo WHERE UserType != 1", con);
                sreader = scmd.ExecuteReader();
                if (sreader.HasRows)
                {
                    while (sreader.Read())
                    {
                        totalRows = Convert.ToInt32(sreader[0].ToString());
                    }
                }
                sreader.Close();

                string SelQuery = "SELECT a.ID AS EmpID,a.UserName,a.UserType,c.Privilage AS UserRole,b.EmpName,b.EmpGender,b.EmpPhone,b.EmpEmail,b.EmpDob,b.EmpPhotoPath,ed.Designation,ed.ID AS DesigType FROM EmployeeInfo b INNER JOIN UserInfo a ON a.ID=b.EmpId INNER JOIN UserPrivilages c ON (a.UserType=c.Id AND a.UserType != 1) INNER JOIN EmpDesignation ed ON b.EmpDesignation = ed.ID ORDER BY b.EmpName ASC OFFSET @startIndex ROWS FETCH NEXT @BlockSize ROWS ONLY";
                SqlDataAdapter da = new SqlDataAdapter(SelQuery, con);
                da.SelectCommand.Parameters.AddWithValue("startIndex", startIndex);
                da.SelectCommand.Parameters.AddWithValue("BlockSize", BlockSize);
                da.Fill(dt);

                if (dt != null && dt.Rows.Count > 0)
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        em = new EmployeeModel();

                        em.NoMoreData = totalRows <= (startIndex + BlockSize);
                        em.EmpID = Convert.ToInt32(row["EmpID"].ToString());
                        em.EmpName = row["EmpName"].ToString();
                        em.UserName = row["UserName"].ToString();
                        em.Gender = row["EmpGender"].ToString().TrimEnd();
                        em.PhoneNumber = row["EmpPhone"].ToString();
                        em.EmailId = row["EmpEmail"].ToString();
                        em.DateOfBirth = (row["EmpDob"].ToString()).Split(' ')[0];
                        em.UserRole = row["UserRole"].ToString().TrimEnd();
                        em.Usertype = Convert.ToInt32(row["UserType"].ToString());
                        em.DesigType = Convert.ToInt32(row["DesigType"].ToString());
                        em.Designation = row["Designation"].ToString().TrimEnd();
                        em.UserPhotoPath = row["EmpPhotoPath"].ToString();

                        empDetails.Add(em);
                    }
                }

                con.Close();
                scmd.Dispose();
            }
            return empDetails;
        }

        public static string AddEmployee(EmployeeModel em)
        {
            try
            {
                string rtrnStr = "";
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["hrmscon"].ConnectionString))
                {
                    con.Open();

                    SqlCommand cmd = new SqlCommand("SELECT ID FROM UserInfo WHERE UPPER(UserName) = @UserNameUpper", con);
                    cmd.Parameters.AddWithValue("UserNameUpper", em.UserName.ToUpper());
                    int idDup = Convert.ToInt32(cmd.ExecuteScalar());

                    cmd = new SqlCommand("SELECT ID FROM EmployeeInfo WHERE EmpPhone = @empPhone", con);
                    cmd.Parameters.AddWithValue("empPhone", em.PhoneNumber);
                    int phoneDup = Convert.ToInt32(cmd.ExecuteScalar());

                    cmd = new SqlCommand("SELECT ID FROM EmployeeInfo WHERE UPPER(EmpEmail) = @empEmailUpper", con);
                    cmd.Parameters.AddWithValue("empEmailUpper", em.EmailId.ToUpper());
                    int emaildup = Convert.ToInt32(cmd.ExecuteScalar());

                    if (idDup > 0)
                    {
                        rtrnStr = rtrnStr + "UD:";
                    }
                    if (phoneDup > 0)
                    {
                        rtrnStr = rtrnStr + "PD:";
                    }
                    if (emaildup > 0)
                    {
                        rtrnStr = rtrnStr + "ED:";
                    }

                    if (string.IsNullOrEmpty(rtrnStr))
                    {
                        cmd = new SqlCommand("InsertEmployeeDetailsMVC", con);
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@empname", em.EmpName);
                        cmd.Parameters.AddWithValue("@empusername", em.UserName);
                        cmd.Parameters.AddWithValue("@emppassword", em.Password);
                        cmd.Parameters.AddWithValue("@empgender", em.Gender);
                        cmd.Parameters.AddWithValue("@empphone", em.PhoneNumber);
                        cmd.Parameters.AddWithValue("@empmail", em.EmailId);
                        cmd.Parameters.AddWithValue("@usertype", Convert.ToInt32(em.Usertype));
                        cmd.Parameters.AddWithValue("@designation", Convert.ToInt32(em.DesigType));
                        cmd.Parameters.AddWithValue("@empdob", Convert.ToDateTime(em.DateOfBirth));
                        cmd.Parameters.AddWithValue("@empid", 0);
                        cmd.Parameters.AddWithValue("@UserId", 0);
                        cmd.Parameters.AddWithValue("@casual", 0);
                        cmd.Parameters.AddWithValue("@festive", 0);
                        cmd.Parameters.AddWithValue("@sick", 0);
                        cmd.Parameters.AddWithValue("@year", DateTime.Now.Year);
                        cmd.Parameters.AddWithValue("@empphotopath", em.UserPhotoPath);

                        cmd.ExecuteNonQuery();

                        rtrnStr = "OK:";
                    }
                    con.Close();
                }

                return rtrnStr;
            }
            catch (Exception ex)
            {
                return "ERROR:";
            }
        }

        public static bool RemoveEmployee(int EmpID)
        {
            bool flag = false;
            try
            {
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["hrmscon"].ConnectionString))
                {
                    con.Open();
                    SqlCommand cmd1 = new SqlCommand("RemoveEmployee", con);
                    cmd1.CommandType = CommandType.StoredProcedure;
                    cmd1.Parameters.AddWithValue("@empid", EmpID);
                    cmd1.ExecuteNonQuery();

                    flag = true;
                }
            }
            catch (Exception ex)
            {
                flag = false;
            }
            return flag;
        }

        public static string UpdateProfile(EmployeeModel em, bool UsrIconUp = false)
        {
            string rtrnStr = "";
            try
            {
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["hrmscon"].ConnectionString))
                {
                    con.Open();
                    SqlCommand cmd = null;

                    if (!UsrIconUp)
                    {
                        cmd = new SqlCommand("SELECT ID,Password FROM UserInfo WHERE ID = @EmpId", con);
                        cmd.Parameters.AddWithValue("EmpId", em.EmpID);                       

                        SqlDataReader sreader = cmd.ExecuteReader();

                        if (sreader.HasRows)
                        {
                            string stordPwd = "";
                            while (sreader.Read())
                            {
                                stordPwd = sreader["Password"].ToString();
                            }

                            sreader.Close();

                            if (Helpers.Helper.matchPassword(em.Password, stordPwd))
                            {
                                cmd = new SqlCommand("UPDATE UserInfo SET Password = @Password,UserType = @Usertype WHERE ID = @EmpID", con);
                                cmd.Parameters.AddWithValue("Password", Helpers.Helper.HashPassword(em.Password));
                                cmd.Parameters.AddWithValue("Usertype", em.Usertype);
                                cmd.Parameters.AddWithValue("EmpID", em.EmpID);
                                cmd.ExecuteNonQuery();

                                cmd = new SqlCommand("UPDATE EmployeeInfo SET EmpName='" + em.EmpName + "',EmpPhone='" + em.PhoneNumber + "',EmpEmail='" + em.EmailId + "',EmpDob='" + em.DateOfBirth + "' WHERE EmpId='" + em.EmpID + "'", con);
                                cmd.Parameters.AddWithValue("EmpName", em.EmpName);
                                cmd.Parameters.AddWithValue("PhoneNumber", em.PhoneNumber);
                                cmd.Parameters.AddWithValue("EmailId", em.EmailId);
                                cmd.Parameters.AddWithValue("DateOfBirth", em.DateOfBirth);
                                cmd.Parameters.AddWithValue("EmpID", em.EmpID);

                                int rtrnRw = cmd.ExecuteNonQuery();
                                if (rtrnRw <= 0)
                                {
                                    rtrnStr = "ERROR:";
                                }
                            }
                            else
                            {
                                rtrnStr = "PM:";
                            }
                        }
                    }
                    else
                    {
                        cmd = new SqlCommand("UPDATE EmployeeInfo SET EmpPhotoPath=@UserPhotoPath WHERE EmpId = @EmpID", con);
                        cmd.Parameters.AddWithValue("UserPhotoPath", em.UserPhotoPath);
                        cmd.Parameters.AddWithValue("EmpID", em.EmpID);

                        int rtrnRw = cmd.ExecuteNonQuery();
                        if (rtrnRw <= 0)
                        {
                            rtrnStr = "ERROR";
                        }
                        else
                        {
                            rtrnStr = "OK";
                        }
                    }
                }

                return rtrnStr;
            }
            catch (Exception ex)
            {
                return "ERROR:";
            }
        }

        public static IEnumerable<SelectListItem> GetRoleSelectList()
        {
            DataTable dt = new DataTable();
            SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM [UserPrivilages]", ConfigurationManager.ConnectionStrings["hrmscon"].ConnectionString);
            da.Fill(dt);
            return
                dt.AsEnumerable().Select(u => new SelectListItem
                {
                    Value = Convert.ToString(u.Field<int>("Id")),
                    Text = u.Field<string>("Privilage")
                });
        }

        public static DataTable getEmployeeDesignationList()
        {
            DataTable dt = new DataTable();
            SqlDataAdapter da = null;
            da = new SqlDataAdapter("SELECT * FROM EmpDesignation", ConfigurationManager.ConnectionStrings["hrmscon"].ConnectionString);
            da.Fill(dt);
            return dt;
        }

        public static void createResetPasswordToken(string empId, string token)
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["hrmscon"].ConnectionString))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("INSERT INTO PasswordResetToken VALUES(@empId,@token,@created)", con);
                cmd.Parameters.AddWithValue("empId", empId);
                cmd.Parameters.AddWithValue("token", token);
                cmd.Parameters.AddWithValue("created", DateTime.UtcNow.AddHours(4).ToString());
                cmd.ExecuteNonQuery();
                con.Close();
            }
        }

        public static void updateResetPasswordToken(string empId, string token)
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["hrmscon"].ConnectionString))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("UPDATE PasswordResetToken SET Created = @created WHERE EmpId = @empId AND Token = @token", con);
                cmd.Parameters.AddWithValue("empId", empId);
                cmd.Parameters.AddWithValue("token", token);
                cmd.Parameters.AddWithValue("created", DateTime.UtcNow.ToString());
                cmd.ExecuteNonQuery();
                con.Close();
            }
        }

        public static bool validateResetPasswordToken(string empId, string token)
        {
            bool rtrnFlag = false;
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["hrmscon"].ConnectionString))
            {
                con.Open();
                SqlDataReader sreader = null;

                SqlCommand cmd = new SqlCommand("SELECT Token,Created FROM PasswordResetToken WHERE EmpId = @empId AND Token = @token", con);
                cmd.Parameters.AddWithValue("empId", empId);
                cmd.Parameters.AddWithValue("token", token);
                sreader = cmd.ExecuteReader();
                string created = "";
                if (sreader.HasRows)
                {
                    while (sreader.Read())
                    {
                        created = sreader["Created"].ToString();
                    }
                }
                sreader.Close();

                if (DateTime.UtcNow <= Convert.ToDateTime(created))
                {
                    rtrnFlag = true;
                }

                con.Close();
            }

            return rtrnFlag;
        }

        #endregion

        #region Manage Attendance        

        public static List<AttendanceModel> GetEmpPunchDetails(int empid, string startDate = null, string endDate = null, bool isReport = false, int BlockNumber = 1, int BlockSize = 1)
        {
            try
            {
                string sdate = "";
                string edate = "";
                int startIndex = BlockNumber;

                if (!string.IsNullOrEmpty(startDate) && !string.IsNullOrEmpty(endDate))
                {
                    sdate = startDate.ToString().Split(' ')[0];
                    edate = endDate.ToString().Split(' ')[0] + " " + "23:59:58.000";
                }
                else if (string.IsNullOrEmpty(endDate))
                {
                    sdate = startDate.ToString().Split(' ')[0];
                    edate = DateTime.UtcNow.ToString().Split(' ')[0] + " " + "23:59:58.000";
                }

                DataTable dt = new DataTable();
                SqlDataAdapter da = null;
                SqlDataReader sreader = null;
                int totalRows = 0;

                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["hrmscon"].ConnectionString))
                {
                    con.Open();
                    SqlCommand scmd = new SqlCommand("SELECT COUNT(PunchinTime) FROM Attendance WHERE (PunchinTime BETWEEN @sdate AND @edate) AND EmpId = @empid", con);
                    scmd.Parameters.AddWithValue("sdate", sdate);
                    scmd.Parameters.AddWithValue("edate", edate);
                    scmd.Parameters.AddWithValue("empid", empid);

                    sreader = scmd.ExecuteReader();
                    if (sreader.HasRows)
                    {
                        while (sreader.Read())
                        {
                            totalRows = Convert.ToInt32(sreader[0].ToString());
                        }
                    }
                    sreader.Close();

                    if (isReport)
                    {
                        da = new SqlDataAdapter("SELECT PunchinTime,PunchoutTime FROM Attendance WHERE (PunchinTime BETWEEN @sdate AND @edate) AND EmpId = @empid ORDER BY PunchinTime", con);
                    }
                    else
                    {
                        da = new SqlDataAdapter("SELECT PunchinTime,PunchoutTime FROM Attendance WHERE (PunchinTime BETWEEN @sdate AND @edate) AND EmpId = @empid ORDER BY PunchinTime OFFSET @startIndex ROWS FETCH NEXT @blockSize ROWS ONLY", con);
                        da.SelectCommand.Parameters.AddWithValue("startIndex", startIndex);
                        da.SelectCommand.Parameters.AddWithValue("blockSize", BlockSize);
                    }
                    da.SelectCommand.Parameters.AddWithValue("sdate", sdate);
                    da.SelectCommand.Parameters.AddWithValue("edate", edate);
                    da.SelectCommand.Parameters.AddWithValue("empid", empid);
                    da.Fill(dt);

                    con.Close();
                    scmd.Dispose();
                }
                List<AttendanceModel> attList = new List<AttendanceModel>();

                if (dt != null && dt.Rows.Count > 0)
                {
                    DateTime pi = new DateTime();
                    DateTime po = new DateTime();

                    AttendanceModel am = null;
                    foreach (DataRow row in dt.Rows)
                    {
                        am = new AttendanceModel();
                        am.RowCount = totalRows;
                        if (!row["PunchinTime"].Equals(DBNull.Value))
                        {
                            pi = Convert.ToDateTime(row["PunchinTime"]);
                            am.PunchinTime = pi.ToString("yyyy-MM-dd hh:mm:ss tt");
                        }

                        if (!row["PunchoutTime"].Equals(DBNull.Value))
                        {
                            po = Convert.ToDateTime(row["PunchoutTime"]);
                            am.PunchoutTime = po.ToString("yyyy-MM-dd hh:mm:ss tt");
                        }
                        else
                        {
                            po = pi;
                        }

                        TimeSpan ts = po - pi;
                        am.Duration = Helpers.Helper.getDuration(ts);
                        am = Helpers.Helper.convertDateTimeFormat(am);
                        attList.Add(am);
                    }
                }
                return attList;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public static AttendanceModel GetEmployeeAttendanceDetails(int empId)
        {
            try
            {
                DataTable dt = new DataTable();
                string date = DateTime.Now.ToString().Split(' ')[0];
                SqlDataAdapter da = new SqlDataAdapter("SELECT TOP 1 PunchinTime,PunchoutTime FROM Attendance WHERE EmpId = @empId ORDER BY PunchinTime DESC", ConfigurationManager.ConnectionStrings["hrmscon"].ConnectionString);
                da.SelectCommand.Parameters.AddWithValue("empId", empId);
                da.Fill(dt);

                AttendanceModel am = null;
                if (dt != null && dt.Rows.Count > 0)
                {
                    am = new AttendanceModel();
                    //em.PunchinTime = (!string.IsNullOrEmpty(dt.Rows[0]["PunchinTime"].ToString())) ? Convert.ToDateTime(dt.Rows[0]["PunchinTime"]).ToString("yyyy-MM-dd hh:mm:ss tt") : "";
                    //em.PunchoutTime = (!string.IsNullOrEmpty(dt.Rows[0]["PunchoutTime"].ToString())) ? Convert.ToDateTime(dt.Rows[0]["PunchoutTime"]).ToString("yyyy-MM-dd hh:mm:ss tt") : "";
                    am.PunchinTime = (!string.IsNullOrEmpty(dt.Rows[0]["PunchinTime"].ToString())) ? (dt.Rows[0]["PunchinTime"]).ToString() : "";
                    am.PunchoutTime = (!string.IsNullOrEmpty(dt.Rows[0]["PunchoutTime"].ToString())) ? (dt.Rows[0]["PunchoutTime"]).ToString() : "";
                }
                return am;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public static bool AddAttendance(AttendanceModel am, int type)
        {
            bool rtrn = false;
            try
            {
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["hrmscon"].ConnectionString))
                {
                    con.Open();
                    if (type == 1)
                    {
                        SqlCommand cmd1 = new SqlCommand("INSERT INTO Attendance(EmpId,PunchinTime) VALUES(@EmpID,@PunchinTime) ", con);
                        cmd1.Parameters.AddWithValue("EmpID", am.EmpID);
                        cmd1.Parameters.AddWithValue("PunchinTime", am.PunchinTime);
                        cmd1.ExecuteNonQuery();
                    }
                    else if (type == 2)
                    {
                        string pin = am.PunchinTime;

                        SqlCommand cmd4 = new SqlCommand("UPDATE Attendance SET PunchoutTime = @PunchoutTime where ID = (Select ID from Attendance where CONVERT(datetime,PunchinTime) = @pin AND EmpId = @EmpID)", con);
                        cmd4.Parameters.AddWithValue("PunchoutTime", am.PunchoutTime);
                        cmd4.Parameters.AddWithValue("pin", pin);
                        cmd4.Parameters.AddWithValue("EmpID", am.EmpID);
                        cmd4.ExecuteNonQuery();
                    }

                    con.Close();
                    rtrn = true;
                }
            }
            catch (Exception ex)
            {
                rtrn = false;
            }
            return rtrn;
        }

        #endregion

        #region Manage Leaves

        public static IEnumerable<SelectListItem> GetLeaveTypes()
        {
            try
            {
                DataTable dt = new DataTable();
                SqlDataAdapter da = new SqlDataAdapter("SELECT Id,Type FROM LeaveType", ConfigurationManager.ConnectionStrings["hrmscon"].ConnectionString);
                da.Fill(dt);

                return dt.AsEnumerable().Select(u => new SelectListItem
                {
                    Value = Convert.ToString(u.Field<int>("Id")),
                    Text = u.Field<string>("Type")
                });

            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public static DataTable GetLeaveStatistics(int EmpId)
        {
            try
            {
                DataTable dt = new DataTable();
                SqlDataAdapter da = null;
                da = new SqlDataAdapter("SELECT [EmpId],[CasualLeave],[FestiveLeave],[SickLeave],[LossOfPay] FROM LeaveStatistics WHERE [EmpId] = @EmpId AND Year = @year", ConfigurationManager.ConnectionStrings["hrmscon"].ConnectionString);
                da.SelectCommand.Parameters.AddWithValue("EmpId", EmpId);
                da.SelectCommand.Parameters.AddWithValue("year", DateTime.Now.Year);
                da.Fill(dt);
                return dt;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public static List<LeaveModel> GetEmployeeLeaveDetails(int EmpId, int userType, LeaveModel lv = null, bool IsReport = false, int BlockNumber = 1, int BlockSize = 1)
        {
            LeaveModel li = null;
            List<LeaveModel> linfo = new List<LeaveModel>();
            SqlDataAdapter da = null;
            DataTable dt = new DataTable();
            SqlDataReader sreader = null;
            int totalRows = 0;
            int startIndex = BlockNumber;

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["hrmscon"].ConnectionString))
            {
                con.Open();
                SqlCommand scmd = new SqlCommand("SELECT COUNT(FromDate) FROM EmployeeLeaveInfo WHERE ((FromDate BETWEEN @FromDate AND @ToDate) OR (ToDate BETWEEN @FromDate AND @ToDate)) AND EmpId = @empid", con);
                scmd.Parameters.AddWithValue("FromDate", lv._fromdate);
                scmd.Parameters.AddWithValue("ToDate", lv._todate);
                scmd.Parameters.AddWithValue("empid", EmpId);

                sreader = scmd.ExecuteReader();
                if (sreader.HasRows)
                {
                    while (sreader.Read())
                    {
                        totalRows = Convert.ToInt32(sreader[0].ToString());
                    }
                }
                sreader.Close();

                if (userType == 1)
                {
                    da = new SqlDataAdapter("SELECT eli.EmpId,eli.FromDate,eli.ToDate,lt.Type,eli.Status,eli.Comments,eli.Id As LeaveID,eli.DurationType,lt.Id AS LeaveTypeID FROM EmployeeLeaveInfo eli INNER JOIN LeaveType lt ON eli.LeaveType=lt.Id WHERE CONVERT(date,FromDate) BETWEEN @startDate AND @endDate AND eli.Status != 3 ORDER BY eli.FromDate DESC", ConfigurationManager.ConnectionStrings["hrmscon"].ConnectionString);
                    da.SelectCommand.Parameters.AddWithValue("startDate", lv._fromdate);
                    da.SelectCommand.Parameters.AddWithValue("endDate", lv._todate);
                }
                else if (userType != 1)
                {
                    //if (lv == null)
                    //{
                    //    da = new SqlDataAdapter("SELECT eli.EmpId,eli.FromDate,eli.ToDate,lt.Type,eli.Status,eli.Comments,eli.Id As LeaveID,eli.DurationType,lt.Id AS LeaveTypeID FROM EmployeeLeaveInfo eli INNER JOIN LeaveType lt ON eli.LeaveType=lt.Id WHERE eli.EmpId=@EmpId ORDER BY eli.FromDate", ConfigurationManager.ConnectionStrings["hrmscon"].ConnectionString);
                    //    da.SelectCommand.Parameters.AddWithValue("EmpId", EmpId);
                    //}
                    //else
                    //{
                    if (IsReport)
                    {
                        da = new SqlDataAdapter("SELECT eli.EmpId,eli.FromDate,eli.ToDate,lt.Type,eli.Status,eli.Comments,eli.Id As LeaveID,eli.DurationType,lt.Id AS LeaveTypeID FROM EmployeeLeaveInfo eli INNER JOIN LeaveType lt ON eli.LeaveType=lt.Id WHERE eli.EmpId=@EmpId AND eli.Status IN (1,2) AND ((FromDate BETWEEN @FromDate AND @ToDate) OR (ToDate BETWEEN @FromDate AND @ToDate)) ORDER BY eli.FromDate", con);
                    }
                    else
                    {
                        da = new SqlDataAdapter("SELECT eli.EmpId,eli.FromDate,eli.ToDate,lt.Type,eli.Status,eli.Comments,eli.Id As LeaveID,eli.DurationType,lt.Id AS LeaveTypeID FROM EmployeeLeaveInfo eli INNER JOIN LeaveType lt ON eli.LeaveType=lt.Id WHERE eli.EmpId=@EmpId AND ((FromDate BETWEEN @FromDate AND @ToDate) OR (ToDate BETWEEN @FromDate AND @ToDate)) ORDER BY eli.FromDate OFFSET @startIndex ROWS FETCH NEXT @blockSize ROWS ONLY", con);
                        da.SelectCommand.Parameters.AddWithValue("startIndex", startIndex);
                        da.SelectCommand.Parameters.AddWithValue("blockSize", BlockSize);
                    }

                    //  da = (IsReport) ? new SqlDataAdapter("SELECT eli.EmpId,eli.FromDate,eli.ToDate,lt.Type,eli.Status,eli.Comments,eli.Id As LeaveID,eli.DurationType,lt.Id AS LeaveTypeID FROM EmployeeLeaveInfo eli INNER JOIN LeaveType lt ON eli.LeaveType=lt.Id WHERE eli.EmpId=@EmpId AND eli.Status IN (1,2) AND ((FromDate BETWEEN @FromDate AND @ToDate) OR (ToDate BETWEEN @FromDate AND @ToDate)) ORDER BY eli.FromDate", ConfigurationManager.ConnectionStrings["hrmscon"].ConnectionString) :
                    //new SqlDataAdapter("SELECT eli.EmpId,eli.FromDate,eli.ToDate,lt.Type,eli.Status,eli.Comments,eli.Id As LeaveID,eli.DurationType,lt.Id AS LeaveTypeID FROM EmployeeLeaveInfo eli INNER JOIN LeaveType lt ON eli.LeaveType=lt.Id WHERE eli.EmpId=@EmpId AND ((FromDate BETWEEN @FromDate AND @ToDate) OR (ToDate BETWEEN @FromDate AND @ToDate)) ORDER BY eli.FromDate", ConfigurationManager.ConnectionStrings["hrmscon"].ConnectionString);

                    da.SelectCommand.Parameters.AddWithValue("EmpId", EmpId);
                    da.SelectCommand.Parameters.AddWithValue("FromDate", lv._fromdate);
                    da.SelectCommand.Parameters.AddWithValue("ToDate", lv._todate);
                    //}
                }
                da.Fill(dt);

                con.Close();
                scmd.Dispose();
            }

            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataRow row in dt.Rows)
                {
                    li = new LeaveModel();
                    li.RowCount = totalRows;
                    li._lvId = Convert.ToInt32(row["LeaveID"].ToString());
                    li.EmpID = Convert.ToInt32(row["EmpId"].ToString());
                    li._fromdate = row["FromDate"].ToString().Split(' ')[0];
                    li._todate = row["ToDate"].ToString().Split(' ')[0];
                    li._leaveType = !string.IsNullOrEmpty(row["LeaveTypeID"].ToString()) ? Convert.ToInt32(row["LeaveTypeID"].ToString()) : 0;
                    li._strLvType = row["Type"].ToString();
                    li._leavedurationtype = row["DurationType"].ToString();
                    li._leaveDurTypeInt = (li._leavedurationtype.Equals("Full Day")) ? 1 : 2;
                    li._comments = row["Comments"].ToString();

                    DateTime fd = Convert.ToDateTime(li._fromdate.ToString());
                    DateTime td = Convert.ToDateTime(li._todate.ToString());
                    li.RtrnArry = CalculateLeaveStatistics(fd, td, li._strLvType.TrimEnd(), li._leavedurationtype.TrimEnd(), li.EmpID);

                    switch ((!string.IsNullOrEmpty(row["Status"].ToString())) ? Convert.ToInt32(row["Status"].ToString()) : 0)
                    {
                        case -1://rejected state
                            li._status = false;
                            li._rejected = true;
                            li._cancelled = false;
                            li._leaveStatus = "REJECTED";
                            break;
                        case 1://pending state
                            li._status = false;
                            li._rejected = false;
                            li._cancelled = false;
                            li._leaveStatus = "PENDING";
                            break;
                        case 2://accepted state    
                            li._status = true;
                            li._rejected = false;
                            li._cancelled = false;
                            li._leaveStatus = "APPROVED";
                            break;
                        case 3: //cancelled state               
                            li._status = false;
                            li._rejected = false;
                            li._cancelled = true;
                            li._leaveStatus = "CANCELLED";
                            break;
                        default:
                            break;
                    }
                    linfo.Add(li);
                }
            }
            return linfo;
        }

        public static void MaintainLeaves()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["hrmscon"].ConnectionString))
                {
                    con.Open();
                    SqlCommand cmd1 = new SqlCommand("SELECT ID FROM LeaveStatistics WHERE Year = @year", con);
                    cmd1.Parameters.AddWithValue("year", DateTime.Now.Year);
                    int id = Convert.ToInt32(cmd1.ExecuteScalar());

                    if (id <= 0)
                    {
                        cmd1 = new SqlCommand("AddLeaveInfo", con);
                        cmd1.CommandType = CommandType.StoredProcedure;
                        cmd1.Parameters.AddWithValue("@count", 0);
                        cmd1.Parameters.AddWithValue("@loopVar", 0);
                        cmd1.Parameters.AddWithValue("@i", 0);
                        cmd1.Parameters.AddWithValue("@casual", 0.0);
                        cmd1.Parameters.AddWithValue("@festive", 0.0);
                        cmd1.Parameters.AddWithValue("@sick", 0.0);
                        cmd1.Parameters.AddWithValue("@year", DateTime.Now.Year);
                        cmd1.ExecuteNonQuery();
                    }
                    con.Close();
                }
            }
            catch (Exception ex)
            {
            }
        }

        public static string AddLeave(LeaveModel lm)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["hrmscon"].ConnectionString))
                {
                    con.Open();
                    int existId = 0;
                    bool flag = false;
                    int status = 1;

                    SqlCommand scmd = new SqlCommand("SELECT Id FROM EmployeeLeaveInfo WHERE FromDate = '" + lm._fromdate + "' AND ToDate = '" + lm._todate + "' AND EmpId = @empId AND LeaveType = @lvType AND Status NOT IN (3,-1) ", con);
                    //scmd.Parameters.AddWithValue("fromDate", lm._fromdate);
                    //scmd.Parameters.AddWithValue("toDate", lm._todate);
                    scmd.Parameters.AddWithValue("empId", lm.EmpID);
                    scmd.Parameters.AddWithValue("lvType", lm._leaveType);

                    SqlDataReader sreader = scmd.ExecuteReader();
                    if (sreader.HasRows)
                    {
                        while (sreader.Read())
                        {
                            existId = Convert.ToInt32(sreader[0].ToString());
                        }
                    }
                    sreader.Close();
                    if (existId > 0)
                    {
                        con.Close();
                        return "EXISTS";
                    }
                    else
                    {
                        try
                        {
                            SqlCommand cmd2 = new SqlCommand("INSERT INTO EmployeeLeaveInfo VALUES(@empId,@fromdate,@todate,@leaveType,@status,@comments,@leavedurationtype)", con);

                            cmd2.Parameters.AddWithValue("empId", lm.EmpID);
                            cmd2.Parameters.AddWithValue("fromdate", lm._fromdate);
                            cmd2.Parameters.AddWithValue("todate", lm._todate);
                            cmd2.Parameters.AddWithValue("leaveType", lm._leaveType);
                            cmd2.Parameters.AddWithValue("status", status);
                            cmd2.Parameters.AddWithValue("comments", lm._comments);
                            cmd2.Parameters.AddWithValue("leavedurationtype", lm._leavedurationtype);
                            cmd2.ExecuteNonQuery();
                            con.Close();
                            flag = true;
                        }
                        catch (Exception ex)
                        {
                            flag = false;
                        }

                        if (flag)
                        {
                            UpdateLeaveStatistics(lm);
                            con.Close();
                            return "OK";
                        }
                        else
                        {
                            con.Close();
                            return "ERROR";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return "ERROR";
            }
        }

        public static string UpdateLeave(LeaveModel lm, int userType)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["hrmscon"].ConnectionString))
                {
                    con.Open();
                    int existId = 0;
                    string rtrnStr = "";
                    ArrayList rtrnArrExis = new ArrayList();

                    if (userType != 1)
                    {
                        bool lvDupFlag = false;

                        #region Duplicate checking
                        if (!lm._cancelled)
                        {
                            SqlCommand scmd = new SqlCommand("SELECT Id FROM EmployeeLeaveInfo WHERE FromDate=@FromDate AND ToDate=@ToDate AND EmpId=@EmpId AND LeaveType=@leaveType AND Id !=@lvId AND Status NOT IN (3,-1)", con);
                            scmd.Parameters.AddWithValue("FromDate", lm._fromdate);
                            scmd.Parameters.AddWithValue("ToDate", lm._todate);
                            scmd.Parameters.AddWithValue("EmpId", lm.EmpID);
                            scmd.Parameters.AddWithValue("leaveType", lm._leaveType);
                            scmd.Parameters.AddWithValue("lvId", lm._lvId);

                            SqlDataReader sreader = scmd.ExecuteReader();

                            if (sreader.HasRows)
                            {
                                while (sreader.Read())
                                {
                                    existId = Convert.ToInt32(sreader[0].ToString());
                                }
                            }
                            sreader.Close();
                            if (existId > 0)
                            {
                                con.Close();
                                rtrnStr = "EXISTS";
                                lvDupFlag = true;
                            }
                        }
                        #endregion

                        if (!lvDupFlag)
                        {
                            DataTable dt = new DataTable();
                            SqlDataAdapter da = new SqlDataAdapter("SELECT [FromDate],[ToDate],[DurationType] FROM EmployeeLeaveInfo WHERE [EmpId] =@empId AND [Id] = @lvId ", ConfigurationManager.ConnectionStrings["hrmscon"].ConnectionString);
                            da.SelectCommand.Parameters.AddWithValue("empId", lm.EmpID);
                            da.SelectCommand.Parameters.AddWithValue("lvId", lm._lvId);
                            da.Fill(dt);
                            if (dt != null && dt.Rows.Count > 0)
                            {
                                DateTime frmdt = new DateTime();
                                DateTime todt = new DateTime();
                                string LvDurType = "";

                                foreach (DataRow row in dt.Rows)
                                {
                                    frmdt = Convert.ToDateTime(row[0].ToString());
                                    todt = Convert.ToDateTime(row[1].ToString());
                                    LvDurType = row[2].ToString().TrimEnd();
                                }
                                rtrnArrExis = CalculateLeaveStatistics(frmdt, todt, lm._strLvType, LvDurType, lm.EmpID);

                                string query = "UPDATE EmployeeLeaveInfo SET FromDate = @fromdate,ToDate = @todate,Comments = @comments,DurationType = @leavedurationtype WHERE [Id] = @lvId";
                                string query1 = "UPDATE EmployeeLeaveInfo SET FromDate = @fromdate,ToDate = @todate,Comments = @comments,DurationType = @leavedurationtype,Status = @status WHERE [Id] = @lvId";
                                SqlCommand cmd2 = null;

                                cmd2 = new SqlCommand((lm._cancelled) ? query1 : query, con);
                                cmd2.Parameters.AddWithValue("fromdate", lm._fromdate);
                                cmd2.Parameters.AddWithValue("todate", lm._todate);
                                cmd2.Parameters.AddWithValue("comments", lm._comments);
                                cmd2.Parameters.AddWithValue("leavedurationtype", lm._leavedurationtype);
                                if (lm._cancelled)
                                {
                                    cmd2.Parameters.AddWithValue("status", 3);
                                }
                                cmd2.Parameters.AddWithValue("lvId", lm._lvId);
                                cmd2.ExecuteNonQuery();
                                con.Close();

                                UpdateLeaveStatistics(lm, rtrnArrExis);

                                con.Close();
                                rtrnStr = "OK";
                            }
                            else
                            {
                                con.Close();
                                rtrnStr = "ERROR";
                            }
                        }
                    }

                    #region Changing Status by Admin.
                    else
                    {

                    }
                    #endregion

                    return rtrnStr;
                }
            }
            catch (Exception ex)
            {
                return "ERROR";
            }
        }

        public static ArrayList CalculateLeaveStatistics(DateTime from, DateTime to, string leaveType, string LeaveDurationType, int empId)
        {
            int startYear = from.Year;
            int endYear = to.Year;
            double prvLvs = 0.0;
            double nxtLvs = 0.0;
            double leaves = 0.0;
            double NoLeaves = 0.0;
            bool flag = false;
            ArrayList rtrnArr = new ArrayList();

            if (startYear != endYear)
            {
                DateTime lastDay = new DateTime(startYear, 12, 31);
                DateTime firstDay = new DateTime(endYear, to.Month, 1);
                bool prvFlag = false;
                bool nxtFlag = false;

                //for both years.
                if (LeaveDurationType == "Half Day")
                {
                    //previous year
                    prvLvs = Helpers.Helper.GetBusinessDaysCount(from, lastDay);
                    prvLvs = 0.5 * prvLvs;

                    //next year
                    nxtLvs = Helpers.Helper.GetBusinessDaysCount(firstDay, to);
                    nxtLvs = 0.5 * nxtLvs;
                }
                else if (LeaveDurationType == "Full Day")
                {
                    //previous year
                    prvLvs = Helpers.Helper.GetBusinessDaysCount(from, lastDay);

                    //next year
                    nxtLvs = Helpers.Helper.GetBusinessDaysCount(firstDay, to);
                }

                NoLeaves = EnoughLeaves(empId, leaveType, startYear);

                if (NoLeaves == 0.0 || prvLvs > NoLeaves)
                {
                    prvFlag = false;
                }
                else if (prvLvs <= NoLeaves && NoLeaves >= 0)
                {
                    prvFlag = true;
                }

                NoLeaves = EnoughLeaves(empId, leaveType, endYear);

                if (NoLeaves == 0.0 || nxtLvs > NoLeaves)
                {
                    nxtFlag = false;
                }
                else if (nxtLvs <= NoLeaves && NoLeaves >= 0)
                {
                    nxtFlag = true;
                }

                if (!prvFlag || !nxtFlag)
                {
                    flag = false;
                }
                else if (prvFlag && nxtFlag)
                {
                    flag = true;
                }

                rtrnArr.Add(new List<int> { startYear, endYear });
                rtrnArr.Add(new List<double> { prvLvs, nxtLvs });
            }
            else
            {
                if (LeaveDurationType == "Half Day")
                {
                    leaves = Helpers.Helper.GetBusinessDaysCount(from, to);
                    leaves = 0.5 * leaves;
                }
                else if (LeaveDurationType == "Full Day")
                {
                    leaves = Helpers.Helper.GetBusinessDaysCount(from, to);
                }

                NoLeaves = EnoughLeaves(empId, leaveType, startYear);

                if (NoLeaves == 0.0 || leaves > NoLeaves)
                {
                    flag = false;
                }
                else if (leaves <= NoLeaves && NoLeaves >= 0)
                {
                    flag = true;
                }

                rtrnArr.Add(new List<int> { startYear });
                rtrnArr.Add(new List<double> { leaves });
            }

            rtrnArr.Add(flag);
            return rtrnArr;
        }

        private static void UpdateLeaveStatistics(LeaveModel linfo, ArrayList rtrnArrExis = null)
        {
            double leaves = 0.0;
            List<int> yearArr = (List<int>)linfo.RtrnArry[0];
            List<double> leaveArr = (List<double>)linfo.RtrnArry[1];
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["hrmscon"].ConnectionString))
            {
                con.Open();

                for (int i = 0; i < yearArr.Count; i++)
                {
                    leaves = (rtrnArrExis == null) ? leaveArr[i] : ((List<double>)rtrnArrExis[1])[i];

                    switch (linfo._strLvType.TrimEnd())
                    {
                        case "Casual":
                            linfo._casualLeave = leaveArr[i];
                            break;
                        case "Festive":
                            linfo._festiveLeave = leaveArr[i];
                            break;
                        case "Sick":
                            linfo._sickLeave = leaveArr[i];
                            break;
                        default:
                            break;
                    }

                    SqlCommand cmd3 = new SqlCommand("SELECT CasualLeave,FestiveLeave,SickLeave,LossOfPay FROM LeaveStatistics WHERE EmpId = @EmpId AND Year = @year", con);
                    cmd3.Parameters.AddWithValue("EmpId", linfo.EmpID);
                    cmd3.Parameters.AddWithValue("year", yearArr[i]);
                    SqlDataReader rd3 = cmd3.ExecuteReader();
                    double cl = 0.0;
                    double sl = 0.0;
                    double fl = 0.0;
                    //double lp = 0.0;

                    if (rd3.HasRows)
                    {
                        while (rd3.Read())
                        {
                            cl = Convert.ToDouble(rd3[0]) - linfo._casualLeave;
                            fl = Convert.ToDouble(rd3[1]) - linfo._festiveLeave;
                            sl = Convert.ToDouble(rd3[2]) - linfo._sickLeave;
                            //lp = Convert.ToDouble(rd3[3]) - linfo.LossOfPay;

                            switch (linfo._strLvType.TrimEnd())
                            {
                                case "Casual":
                                    cl = (!linfo._cancelled && !linfo._rejected) ? ((linfo._lvId > 0) ? (cl + leaves) : cl) : (cl + 2 * leaves);
                                    break;
                                case "Festive":
                                    fl = (!linfo._cancelled && !linfo._rejected) ? ((linfo._lvId > 0) ? (fl + leaves) : fl) : (fl + 2 * leaves);
                                    break;
                                case "Sick":
                                    sl = (!linfo._cancelled && !linfo._rejected) ? ((linfo._lvId > 0) ? (sl + leaves) : sl) : (sl + 2 * leaves);
                                    break;
                                default:
                                    break;
                            }
                        }
                    }

                    rd3.Close();

                    SqlCommand cmd4 = new SqlCommand("UPDATE LeaveStatistics SET CasualLeave=@cl ,FestiveLeave=@fl,SickLeave=@sl WHERE EmpId=@EmpId AND Year = @year", con);
                    cmd4.Parameters.AddWithValue("cl", cl);
                    cmd4.Parameters.AddWithValue("fl", fl);
                    cmd4.Parameters.AddWithValue("sl", sl);
                    cmd4.Parameters.AddWithValue("EmpId", linfo.EmpID);
                    cmd4.Parameters.AddWithValue("year", yearArr[i]);
                    cmd4.ExecuteNonQuery();
                }
                con.Close();
            }
        }

        public static double EnoughLeaves(int EmpId, string LeaveTypeStr, int startYear)
        {
            try
            {
                string colName = "";
                double NoLeaves = 0.0;
                switch (LeaveTypeStr)
                {
                    case "Casual":
                        colName = "CasualLeave";
                        break;

                    case "Festive":
                        colName = "FestiveLeave";
                        break;

                    case "Sick":
                        colName = "SickLeave";
                        break;

                    default:
                        break;
                }
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["hrmscon"].ConnectionString))
                {
                    con.Open();
                    SqlCommand scmd = new SqlCommand("SELECT " + colName + " FROM LeaveStatistics WHERE  EmpId=@empId AND Year = @year", con);
                    scmd.Parameters.AddWithValue("empId", EmpId);
                    scmd.Parameters.AddWithValue("year", startYear);
                    SqlDataReader sreader = scmd.ExecuteReader();

                    if (sreader.HasRows)
                    {
                        while (sreader.Read())
                        {
                            NoLeaves = Convert.ToDouble(sreader[0].ToString());
                        }
                    }
                    con.Close();
                }
                return NoLeaves;
            }
            catch (Exception ex)
            {
                return 0.0;
            }
        }

        #endregion
    }
}