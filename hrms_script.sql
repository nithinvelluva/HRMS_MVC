USE [master]
GO
/****** Object:  Database [LoginInfo]    Script Date: 2017-02-08 14:32:03 ******/
CREATE DATABASE [LoginInfo]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'LoginInfo', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\LoginInfo.mdf' , SIZE = 6144KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'LoginInfo_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\LoginInfo_log.ldf' , SIZE = 29504KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [LoginInfo] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [LoginInfo].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [LoginInfo] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [LoginInfo] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [LoginInfo] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [LoginInfo] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [LoginInfo] SET ARITHABORT OFF 
GO
ALTER DATABASE [LoginInfo] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [LoginInfo] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [LoginInfo] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [LoginInfo] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [LoginInfo] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [LoginInfo] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [LoginInfo] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [LoginInfo] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [LoginInfo] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [LoginInfo] SET  DISABLE_BROKER 
GO
ALTER DATABASE [LoginInfo] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [LoginInfo] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [LoginInfo] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [LoginInfo] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [LoginInfo] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [LoginInfo] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [LoginInfo] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [LoginInfo] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [LoginInfo] SET  MULTI_USER 
GO
ALTER DATABASE [LoginInfo] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [LoginInfo] SET DB_CHAINING OFF 
GO
ALTER DATABASE [LoginInfo] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [LoginInfo] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [LoginInfo] SET DELAYED_DURABILITY = DISABLED 
GO
USE [LoginInfo]
GO
/****** Object:  UserDefinedFunction [dbo].[SplitString]    Script Date: 2017-02-08 14:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[SplitString]
(	
	@Input NVARCHAR(MAX),
	@Character CHAR(1)
)
RETURNS @Output TABLE (
	Item NVARCHAR(1000)
)
AS
BEGIN
	DECLARE @StartIndex INT, @EndIndex INT

	SET @StartIndex = 1
	IF SUBSTRING(@Input, LEN(@Input) - 1, LEN(@Input)) <> @Character
	BEGIN
		SET @Input = @Input + @Character
	END

	WHILE CHARINDEX(@Character, @Input) > 0
	BEGIN
		SET @EndIndex = CHARINDEX(@Character, @Input)
		
		INSERT INTO @Output(Item)
		SELECT SUBSTRING(@Input, @StartIndex, @EndIndex - 1)
		
		SET @Input = SUBSTRING(@Input, @EndIndex + 1, LEN(@Input))
	END

	RETURN
END

GO
/****** Object:  Table [dbo].[Attendance]    Script Date: 2017-02-08 14:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Attendance](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EmpId] [int] NOT NULL,
	[PunchinTime] [datetime] NULL,
	[PunchoutTime] [datetime] NULL,
	[Notes] [nvarchar](max) NULL,
 CONSTRAINT [PK_Attendance] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EmpDesignation]    Script Date: 2017-02-08 14:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmpDesignation](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Designation] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_EmpDesignation] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EmployeeInfo]    Script Date: 2017-02-08 14:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeInfo](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EmpId] [int] NOT NULL,
	[EmpName] [nvarchar](50) NOT NULL,
	[EmpPhone] [nchar](10) NOT NULL,
	[EmpEmail] [nvarchar](50) NOT NULL,
	[EmpGender] [nchar](10) NOT NULL,
	[EmpDob] [datetime] NOT NULL,
	[EmpPhotoPath] [nvarchar](max) NULL,
	[EmpDesignation] [int] NULL,
 CONSTRAINT [PK_Employee Info] PRIMARY KEY CLUSTERED 
(
	[EmpId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EmployeeLeaveInfo]    Script Date: 2017-02-08 14:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EmployeeLeaveInfo](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpId] [int] NOT NULL,
	[FromDate] [datetime] NULL,
	[ToDate] [datetime] NULL,
	[LeaveType] [int] NULL,
	[Status] [int] NULL,
	[Comments] [varchar](50) NULL,
	[DurationType] [varchar](15) NULL,
 CONSTRAINT [PK_EmployeeLeaveInfo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[HrmsQuery]    Script Date: 2017-02-08 14:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HrmsQuery](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[QuerySubject] [nvarchar](max) NULL,
	[QueryBody] [nvarchar](max) NULL,
	[Date] [datetime] NULL,
	[IsRead] [bit] NULL,
	[EmpId] [int] NULL,
 CONSTRAINT [PK_HrmsQuery] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LeaveStatistics]    Script Date: 2017-02-08 14:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LeaveStatistics](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpId] [int] NOT NULL,
	[CasualLeave] [float] NULL,
	[FestiveLeave] [float] NULL,
	[SickLeave] [float] NULL,
	[LossOfPay] [float] NULL,
	[Year] [int] NULL,
 CONSTRAINT [PK_LeaveStatistics] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LeaveType]    Script Date: 2017-02-08 14:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LeaveType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Type] [nchar](10) NOT NULL,
	[Count] [int] NOT NULL,
 CONSTRAINT [PK_LeaveType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserInfo]    Script Date: 2017-02-08 14:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserInfo](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](max) NOT NULL,
	[UserType] [int] NOT NULL,
 CONSTRAINT [PK_UserInfo] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserPrivilages]    Script Date: 2017-02-08 14:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserPrivilages](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Privilage] [nchar](10) NOT NULL,
 CONSTRAINT [PK_UserPrivilages] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[Attendance] ON 

INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (5, 9, CAST(N'2016-05-30 14:59:08.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (7, 9, CAST(N'2016-05-31 09:48:39.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (14, 9, CAST(N'2016-06-23 16:47:16.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (16, 11, CAST(N'2016-06-23 17:11:27.000' AS DateTime), CAST(N'2016-06-23 17:11:36.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (21, 9, CAST(N'2016-06-27 18:07:28.000' AS DateTime), CAST(N'2016-06-27 18:07:31.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (24, 9, CAST(N'2016-06-29 10:19:02.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (25, 8, CAST(N'2016-06-29 13:19:15.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (26, 8, CAST(N'2016-06-30 10:12:43.000' AS DateTime), CAST(N'2016-06-30 19:06:46.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (27, 8, CAST(N'2016-07-01 09:44:46.000' AS DateTime), CAST(N'2016-07-01 13:11:12.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (28, 8, CAST(N'2016-07-04 09:48:51.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (29, 9, CAST(N'2016-07-04 15:32:33.000' AS DateTime), CAST(N'2016-07-04 15:34:09.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (30, 8, CAST(N'2016-07-05 11:08:06.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (31, 9, CAST(N'2016-07-05 12:51:39.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (32, 11, CAST(N'2016-07-05 13:21:25.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (1030, 8, CAST(N'2016-07-13 14:41:49.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (1031, 9, CAST(N'2016-07-18 10:42:42.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (1032, 9, CAST(N'2016-07-21 10:37:50.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (1034, 8, CAST(N'2016-07-21 15:07:15.000' AS DateTime), CAST(N'2016-07-21 15:07:26.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (1036, 19, CAST(N'2016-07-22 17:25:42.000' AS DateTime), CAST(N'2016-07-22 17:25:45.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (1039, 20, CAST(N'2016-08-01 10:50:54.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (1040, 8, CAST(N'2016-08-01 11:24:36.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (1041, 9, CAST(N'2016-08-01 12:27:49.000' AS DateTime), CAST(N'2016-08-01 12:27:52.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (1042, 1024, CAST(N'2016-08-01 15:21:35.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (1043, 9, CAST(N'2016-08-02 11:57:56.000' AS DateTime), CAST(N'2016-08-02 18:32:12.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (1044, 11, CAST(N'2016-08-02 14:06:18.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (1046, 8, CAST(N'2016-08-02 18:36:47.000' AS DateTime), CAST(N'2016-08-02 18:36:50.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (1047, 8, CAST(N'2016-08-03 15:41:31.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (1048, 9, CAST(N'2016-08-08 16:14:50.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (1049, 9, CAST(N'2016-08-09 13:00:54.000' AS DateTime), CAST(N'2016-08-09 19:21:23.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (1050, 8, CAST(N'2016-08-09 15:46:46.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (1051, 11, CAST(N'2016-08-10 12:13:10.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (1052, 8, CAST(N'2016-08-12 14:45:37.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (1053, 11, CAST(N'2016-08-26 11:01:31.000' AS DateTime), CAST(N'2017-01-21 11:57:19.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (1054, 8, CAST(N'2016-09-02 19:07:19.000' AS DateTime), CAST(N'2016-09-02 19:38:53.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (1055, 9, CAST(N'2016-09-02 19:41:29.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (1056, 9, CAST(N'2016-09-05 11:23:58.000' AS DateTime), CAST(N'2016-09-05 15:30:41.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (2054, 8, CAST(N'2016-09-06 11:14:29.000' AS DateTime), CAST(N'2016-09-06 19:11:54.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (2055, 20, CAST(N'2016-09-06 11:20:38.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (2056, 8, CAST(N'2016-09-07 10:14:09.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (2057, 9, CAST(N'2016-09-07 14:53:42.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (2058, 8, CAST(N'2016-09-08 13:33:55.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (2059, 9, CAST(N'2016-09-08 15:34:12.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (2060, 8, CAST(N'2016-09-09 10:06:08.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (2061, 9, CAST(N'2016-09-09 11:35:19.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (2062, 20, CAST(N'2016-09-09 13:28:34.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (2064, 8, CAST(N'2016-09-19 10:37:33.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (2065, 9, CAST(N'2016-09-19 14:16:56.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (2066, 9, CAST(N'2016-09-20 09:54:00.000' AS DateTime), CAST(N'2016-09-20 16:14:57.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (2067, 8, CAST(N'2016-09-20 10:16:45.000' AS DateTime), CAST(N'2016-09-20 12:24:58.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (2068, 8, CAST(N'2016-09-21 09:43:39.000' AS DateTime), CAST(N'2016-09-21 18:46:21.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (2069, 9, CAST(N'2016-09-21 18:41:58.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (2070, 8, CAST(N'2016-09-22 09:50:17.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (2071, 8, CAST(N'2016-09-23 10:15:44.000' AS DateTime), CAST(N'2016-09-23 16:33:18.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (2072, 9, CAST(N'2016-09-23 10:19:14.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (2073, 1026, CAST(N'2016-09-23 10:21:08.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (2074, 8, CAST(N'2016-09-26 09:56:40.000' AS DateTime), CAST(N'2016-09-26 14:45:13.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (2075, 8, CAST(N'2016-09-27 10:00:29.000' AS DateTime), CAST(N'2016-09-27 14:32:01.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (2076, 8, CAST(N'2016-09-28 17:07:49.000' AS DateTime), CAST(N'2016-09-28 17:13:14.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (2077, 9, CAST(N'2016-09-28 17:17:40.000' AS DateTime), CAST(N'2016-09-28 17:17:41.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (2078, 8, CAST(N'2016-10-03 14:37:24.000' AS DateTime), CAST(N'2016-10-03 18:28:34.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (2079, 8, CAST(N'2016-10-04 12:17:50.000' AS DateTime), CAST(N'2016-10-04 14:55:31.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (2080, 9, CAST(N'2016-10-04 15:55:31.000' AS DateTime), CAST(N'2016-10-04 15:56:13.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (2081, 1031, CAST(N'2016-10-04 16:00:28.000' AS DateTime), CAST(N'2017-01-21 11:55:22.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (2082, 8, CAST(N'2016-10-05 10:09:11.000' AS DateTime), CAST(N'2016-10-05 10:09:23.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (2083, 8, CAST(N'2016-10-07 12:09:02.000' AS DateTime), CAST(N'2016-10-07 16:53:48.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (3081, 9, CAST(N'2016-10-12 11:25:19.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (3082, 9, CAST(N'2016-10-17 10:00:55.000' AS DateTime), CAST(N'2016-10-17 15:37:08.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (3083, 8, CAST(N'2016-10-17 12:07:42.000' AS DateTime), CAST(N'2016-10-17 15:56:08.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (3084, 9, CAST(N'2016-10-18 09:58:03.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (3085, 8, CAST(N'2016-10-18 10:01:28.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (3086, 20, CAST(N'2016-10-18 10:22:32.000' AS DateTime), CAST(N'2016-11-30 17:33:32.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4082, 9, CAST(N'2016-10-19 12:47:10.000' AS DateTime), CAST(N'2016-10-19 12:48:28.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4083, 9, CAST(N'2016-10-20 10:26:08.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4084, 9, CAST(N'2016-10-21 10:08:04.000' AS DateTime), CAST(N'2016-10-21 16:29:22.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4085, 8, CAST(N'2016-10-21 15:58:12.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4086, 9, CAST(N'2016-10-25 10:16:36.000' AS DateTime), CAST(N'2016-10-25 17:24:18.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4093, 9, CAST(N'2016-10-26 10:23:52.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4095, 8, CAST(N'2016-10-26 10:59:40.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4096, 9, CAST(N'2016-10-27 16:23:49.000' AS DateTime), CAST(N'2016-10-27 18:08:28.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4097, 9, CAST(N'2016-10-28 09:55:31.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4098, 9, CAST(N'2016-10-31 10:35:14.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4099, 9, CAST(N'2016-11-01 10:12:44.000' AS DateTime), CAST(N'2016-11-01 18:10:35.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4100, 8, CAST(N'2016-11-01 10:14:20.000' AS DateTime), CAST(N'2016-11-01 18:13:42.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4101, 9, CAST(N'2016-11-02 10:25:33.000' AS DateTime), CAST(N'2016-11-03 10:35:33.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4144, 9, CAST(N'2016-11-03 10:36:33.000' AS DateTime), CAST(N'2016-11-03 17:25:54.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4145, 9, CAST(N'2016-11-04 10:28:45.000' AS DateTime), CAST(N'2016-11-04 15:05:36.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4146, 9, CAST(N'2016-11-04 15:09:31.000' AS DateTime), CAST(N'2016-11-04 17:01:14.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4147, 19, CAST(N'2016-11-04 15:19:38.000' AS DateTime), CAST(N'2016-12-01 11:45:59.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4148, 8, CAST(N'2016-11-05 20:10:22.000' AS DateTime), CAST(N'2016-11-11 10:57:41.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4151, 9, CAST(N'2016-11-07 10:47:27.000' AS DateTime), CAST(N'2016-11-08 10:01:39.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4152, 9, CAST(N'2016-11-08 10:01:41.000' AS DateTime), CAST(N'2016-11-09 11:33:34.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4153, 9, CAST(N'2016-11-09 11:33:36.000' AS DateTime), CAST(N'2016-11-10 10:40:25.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4154, 9, CAST(N'2016-11-10 10:40:26.000' AS DateTime), CAST(N'2016-11-10 18:55:53.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4155, 9, CAST(N'2016-11-11 10:26:29.000' AS DateTime), CAST(N'2016-11-14 10:25:25.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4156, 8, CAST(N'2016-11-11 10:57:42.000' AS DateTime), CAST(N'2016-11-15 10:54:36.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4157, 9, CAST(N'2016-11-14 10:25:46.000' AS DateTime), CAST(N'2016-11-14 17:59:37.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4158, 9, CAST(N'2016-11-15 10:12:47.000' AS DateTime), CAST(N'2016-11-15 18:19:31.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4160, 8, CAST(N'2016-11-15 10:54:39.000' AS DateTime), CAST(N'2016-11-15 18:27:26.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4161, 9, CAST(N'2016-11-16 10:20:01.000' AS DateTime), CAST(N'2016-11-16 18:40:18.000' AS DateTime), NULL)
GO
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4162, 8, CAST(N'2016-11-16 11:53:26.000' AS DateTime), CAST(N'2016-11-16 18:43:22.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4163, 9, CAST(N'2016-11-18 10:26:22.000' AS DateTime), CAST(N'2016-11-18 17:25:11.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4164, 8, CAST(N'2016-11-18 11:17:13.000' AS DateTime), CAST(N'2016-11-21 10:17:39.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4165, 8, CAST(N'2016-11-21 10:17:46.000' AS DateTime), CAST(N'2016-11-23 10:52:48.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4166, 9, CAST(N'2016-11-21 10:19:26.000' AS DateTime), CAST(N'2016-11-21 18:09:12.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4167, 9, CAST(N'2016-11-22 10:42:17.000' AS DateTime), CAST(N'2016-11-23 10:25:22.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4168, 9, CAST(N'2016-11-23 10:25:24.000' AS DateTime), CAST(N'2016-11-23 18:21:51.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4169, 8, CAST(N'2016-11-23 10:52:50.000' AS DateTime), CAST(N'2016-11-29 14:26:59.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4170, 9, CAST(N'2016-11-23 18:22:01.000' AS DateTime), CAST(N'2016-11-23 18:22:07.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (4171, 9, CAST(N'2016-11-24 13:00:52.000' AS DateTime), CAST(N'2016-11-25 10:43:13.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (5170, 9, CAST(N'2016-11-25 10:43:15.000' AS DateTime), CAST(N'2016-11-25 17:23:03.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (5171, 9, CAST(N'2016-11-29 10:14:11.000' AS DateTime), CAST(N'2016-11-29 13:12:49.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (5172, 9, CAST(N'2016-11-29 13:12:52.000' AS DateTime), CAST(N'2016-11-29 17:50:07.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (5173, 8, CAST(N'2016-11-29 14:29:54.000' AS DateTime), CAST(N'2016-11-29 14:30:37.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (5174, 8, CAST(N'2016-11-29 14:30:43.000' AS DateTime), CAST(N'2016-11-29 14:40:28.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (5175, 8, CAST(N'2016-11-29 14:40:32.000' AS DateTime), CAST(N'2016-12-02 20:05:39.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (5176, 9, CAST(N'2016-11-30 10:11:42.000' AS DateTime), CAST(N'2016-11-30 12:13:24.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (5177, 9, CAST(N'2016-11-30 12:38:07.000' AS DateTime), CAST(N'2016-12-01 10:54:52.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (5178, 20, CAST(N'2016-11-30 17:33:34.000' AS DateTime), CAST(N'2017-01-13 16:17:58.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (5179, 9, CAST(N'2016-12-01 10:54:53.000' AS DateTime), CAST(N'2016-12-01 11:17:25.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (5180, 9, CAST(N'2016-12-01 11:17:29.000' AS DateTime), CAST(N'2016-12-01 21:15:27.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (5181, 9, CAST(N'2016-12-02 10:10:41.000' AS DateTime), CAST(N'2016-12-02 19:57:26.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (5182, 8, CAST(N'2016-12-02 20:05:53.000' AS DateTime), CAST(N'2016-12-02 20:24:47.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (5183, 9, CAST(N'2016-12-05 10:28:53.000' AS DateTime), CAST(N'2016-12-09 21:22:52.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (5184, 8, CAST(N'2016-12-05 11:15:44.000' AS DateTime), CAST(N'2016-12-07 15:13:20.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (6183, 8, CAST(N'2016-12-09 21:13:30.000' AS DateTime), CAST(N'2017-01-05 13:06:16.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (6184, 9, CAST(N'2016-12-09 21:23:15.000' AS DateTime), CAST(N'2016-12-14 17:38:34.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (6185, 9, CAST(N'2016-12-20 12:23:04.000' AS DateTime), CAST(N'2016-12-22 10:54:49.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (6186, 9, CAST(N'2016-12-22 13:08:29.000' AS DateTime), CAST(N'2016-12-22 16:01:59.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (6187, 9, CAST(N'2016-12-28 17:21:38.000' AS DateTime), CAST(N'2016-12-30 10:07:36.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (6188, 9, CAST(N'2017-01-03 13:10:34.000' AS DateTime), CAST(N'2017-01-03 17:17:15.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (6189, 9, CAST(N'2017-01-04 12:47:35.000' AS DateTime), CAST(N'2017-01-04 18:18:56.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (6190, 9, CAST(N'2017-01-04 18:19:29.000' AS DateTime), CAST(N'2017-01-04 18:19:43.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (6191, 9, CAST(N'2017-01-05 11:47:48.000' AS DateTime), CAST(N'2017-01-05 14:45:00.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (6192, 8, CAST(N'2017-01-05 13:06:38.000' AS DateTime), CAST(N'2017-01-06 09:20:47.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (6193, 9, CAST(N'2017-01-05 16:07:20.000' AS DateTime), CAST(N'2017-01-05 17:07:42.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (6194, 9, CAST(N'2017-01-05 22:03:26.000' AS DateTime), CAST(N'2017-01-05 22:03:28.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (6195, 8, CAST(N'2017-01-06 09:23:22.000' AS DateTime), CAST(N'2017-01-09 14:33:45.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (6196, 9, CAST(N'2017-01-06 09:29:47.000' AS DateTime), CAST(N'2017-01-09 10:11:42.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (6197, 9, CAST(N'2017-01-09 10:11:45.000' AS DateTime), CAST(N'2017-01-10 11:52:39.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (6198, 9, CAST(N'2017-01-10 11:55:49.000' AS DateTime), CAST(N'2017-01-10 18:45:25.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (6199, 9, CAST(N'2017-01-11 10:28:04.000' AS DateTime), CAST(N'2017-01-11 11:07:00.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (6200, 9, CAST(N'2017-01-11 11:07:08.000' AS DateTime), CAST(N'2017-01-11 11:07:20.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (6201, 9, CAST(N'2017-01-11 11:07:45.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (6202, 9, CAST(N'2017-01-11 11:07:48.000' AS DateTime), CAST(N'2017-01-11 11:08:19.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (6203, 9, CAST(N'2017-01-11 17:24:31.000' AS DateTime), CAST(N'2017-01-11 18:40:27.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (6204, 9, CAST(N'2017-01-12 10:15:27.000' AS DateTime), CAST(N'2017-01-13 10:16:47.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (6205, 9, CAST(N'2017-01-13 10:16:48.000' AS DateTime), CAST(N'2017-01-13 16:53:32.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (6206, 8, CAST(N'2017-01-13 10:17:39.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (6207, 20, CAST(N'2017-01-17 11:09:44.000' AS DateTime), CAST(N'2017-01-17 18:15:49.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (6208, 9, CAST(N'2017-01-17 16:51:15.000' AS DateTime), CAST(N'2017-01-18 10:47:04.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (6209, 20, CAST(N'2017-01-18 10:09:06.000' AS DateTime), CAST(N'2017-01-19 10:06:43.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (6210, 9, CAST(N'2017-01-18 10:47:37.000' AS DateTime), CAST(N'2017-01-19 20:36:15.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (7205, 20, CAST(N'2017-01-19 10:55:52.000' AS DateTime), CAST(N'2017-01-19 20:39:40.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (7206, 11, CAST(N'2017-01-21 11:57:20.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (7207, 9, CAST(N'2017-01-23 10:27:33.000' AS DateTime), CAST(N'2017-01-23 18:07:40.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (7208, 20, CAST(N'2017-01-23 10:43:18.000' AS DateTime), CAST(N'2017-01-27 11:46:18.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (7209, 2065, CAST(N'2017-01-23 21:27:32.000' AS DateTime), CAST(N'2017-01-23 21:30:19.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (7210, 9, CAST(N'2017-01-24 09:42:22.000' AS DateTime), CAST(N'2017-01-26 08:56:43.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (7211, 2065, CAST(N'2017-01-24 09:49:17.000' AS DateTime), CAST(N'2017-01-24 18:11:44.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (7215, 2069, CAST(N'2017-01-25 10:36:37.000' AS DateTime), CAST(N'2017-01-25 10:40:45.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (8212, 9, CAST(N'2017-01-27 10:17:31.000' AS DateTime), CAST(N'2017-01-29 16:40:02.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (8213, 3066, CAST(N'2017-01-27 10:34:09.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (8214, 9, CAST(N'2017-01-30 10:33:39.000' AS DateTime), CAST(N'2017-02-06 11:57:03.000' AS DateTime), NULL)
INSERT [dbo].[Attendance] ([ID], [EmpId], [PunchinTime], [PunchoutTime], [Notes]) VALUES (8215, 9, CAST(N'2017-02-06 11:57:30.000' AS DateTime), CAST(N'2017-02-06 12:04:35.000' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[Attendance] OFF
SET IDENTITY_INSERT [dbo].[EmpDesignation] ON 

INSERT [dbo].[EmpDesignation] ([ID], [Designation]) VALUES (1, N'HR')
INSERT [dbo].[EmpDesignation] ([ID], [Designation]) VALUES (2, N'SOFTWARE ENGINEER')
SET IDENTITY_INSERT [dbo].[EmpDesignation] OFF
SET IDENTITY_INSERT [dbo].[EmployeeInfo] ON 

INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (10, 7, N'Admin User', N'9633078146', N'nithinvelluva@gmail.com', N'M         ', CAST(N'1992-05-28 00:00:00.000' AS DateTime), NULL, 1)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (11, 8, N'Test User', N'1234567890', N'nithinvelluva@gmail.com', N'M         ', CAST(N'1992-05-28 00:00:00.000' AS DateTime), N'../Content/UserIcons/HRMS_d368c596-07ec-4917-a0fc-0c51ee81d0ac.jpg', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (12, 9, N'Nithin N', N'9633078146', N'nithinvelluva@gmail.com', N'M         ', CAST(N'1992-05-28 00:00:00.000' AS DateTime), N'../Content/UserIcons/HRMS_23192809-2d55-4c2e-bb48-802125f8b151.jpg', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (18, 11, N'Rahul', N'1234567890', N'ex@ex.com', N'M         ', CAST(N'1990-05-29 00:00:00.000' AS DateTime), N'../Content/UserIcons/HRMS_b8249cc8-642a-49cc-ae19-97ed499714c4.jpg', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (26, 19, N'Faial J P', N'1234567890', N'faizal.kit@gmail.com', N'M         ', CAST(N'1993-05-27 00:00:00.000' AS DateTime), N'../Content/UserIcons/HRMS_3cd80286-9150-4f1c-901b-1d789405abda.jpg', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (27, 20, N'Jiffy Kuriakose', N'1234567890', N'jiffy@grindan.com', N'F         ', CAST(N'1993-06-28 00:00:00.000' AS DateTime), N'../Content/UserIcons/HRMS_5099dbae-080e-4737-9453-7c1956c2006a.jpg', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (1026, 1019, N'Mohith P', N'1234567890', N'test@domain.com', N'M         ', CAST(N'1992-06-01 00:00:00.000' AS DateTime), N'../Content/UserIcons/HRMS_9868194c-513d-41b3-bf46-2ef7ecb5dc20.jpg', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (1031, 1024, N'Anusree', N'1234567890', N'test@test.com', N'F         ', CAST(N'1991-12-07 00:00:00.000' AS DateTime), N'', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (1032, 1025, N'Annie Manu', N'1234567890', N'test@test.com', N'F         ', CAST(N'1993-08-01 00:00:00.000' AS DateTime), N'', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (1033, 1026, N'Anil', N'1231231232', N'abc@xyz.com', N'M         ', CAST(N'1992-02-11 00:00:00.000' AS DateTime), N'', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (1038, 1031, N'BIBIN K', N'8129671433', N'bibin.onankunju@gmail.com', N'M         ', CAST(N'1990-06-05 00:00:00.000' AS DateTime), N'../Content/UserIcons/HRMS_4ca5601d-a172-4b1f-b19d-494c8d2bb9b1.jpg', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (1048, 1041, N'Sachin', N'1234567890', N'sachin@gmail.com', N'M         ', CAST(N'1991-03-07 00:00:00.000' AS DateTime), N'', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (1049, 1042, N'Sehwag ', N'9876543210', N'sehwag@gmail.com', N'M         ', CAST(N'1990-02-07 00:00:00.000' AS DateTime), N'', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (1051, 1044, N'Tom Cruise', N'9879898989', N'test@test.com', N'M         ', CAST(N'1992-07-22 00:00:00.000' AS DateTime), N'', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (1052, 1045, N'Gangully', N'9777837787', N'ganguly100@gmail.com', N'M         ', CAST(N'1991-02-05 00:00:00.000' AS DateTime), N'', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (2052, 2045, N'z', N'1234567890', N'ds@e.com', N'M         ', CAST(N'1992-12-12 00:00:00.000' AS DateTime), N'', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (2053, 2046, N'uyiy', N'1234567890', N'test@test.co', N'F         ', CAST(N'1992-12-12 00:00:00.000' AS DateTime), N'../Content/UserIcons/HRMS_e88c0d8c-847f-4120-b773-71eaa1c824df.jpg', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (2055, 2048, N'Joseph', N'1234567890', N'test@test.co', N'F         ', CAST(N'1992-12-12 00:00:00.000' AS DateTime), N'../Content/UserIcons/HRMS_e88c0d8c-847f-4120-b773-71eaa1c824df.jpg', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (2056, 2049, N'Hari', N'9876543210', N'test@test.co', N'M         ', CAST(N'1992-12-12 00:00:00.000' AS DateTime), N'../Content/UserIcons/HRMS_6423a582-eb02-480b-9895-6da0a587b43f.jpg', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (2058, 2051, N'Andrew', N'1234567890', N'test@test.co', N'M         ', CAST(N'1992-12-12 00:00:00.000' AS DateTime), N'../Content/UserIcons/HRMS_2a57b2e3-9696-4f6e-a87e-f6a0136b3537.jpg', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (2059, 2052, N'Tom Cruise', N'1234567890', N'test@test.co', N'M         ', CAST(N'1992-12-12 00:00:00.000' AS DateTime), N'../Content/UserIcons/HRMS_99c2e6c8-7210-46ac-8516-a888bdcab032.png', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (2060, 2053, N'dsf', N'9876543210', N'test@test.co', N'M         ', CAST(N'1992-12-12 00:00:00.000' AS DateTime), N'', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (2061, 2054, N'wqd', N'9876543210', N'test@test.co', N'F         ', CAST(N'1992-12-12 00:00:00.000' AS DateTime), N'', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (2064, 2057, N's', N'9876543210', N'test@test.co', N'M         ', CAST(N'1992-12-12 00:00:00.000' AS DateTime), N'', 1)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (2065, 2058, N'Andrew', N'1234567890', N'test@test.co', N'M         ', CAST(N'1992-12-12 00:00:00.000' AS DateTime), N'', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (2067, 2060, N'QA', N'9876543210', N'test@test.co', N'M         ', CAST(N'1992-12-12 00:00:00.000' AS DateTime), N'', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (2069, 2062, N'Super User', N'9876543210', N'nithinvelluva@gmail.com', N'M         ', CAST(N'1992-12-12 00:00:00.000' AS DateTime), N'../Content/UserIcons/HRMS_db6a0c07-2670-44ba-bef8-a603b8476029.jpg', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (2070, 2063, N'Raghav Nair', N'9876543210', N'test@test.co', N'M         ', CAST(N'1992-12-12 00:00:00.000' AS DateTime), N'../Content/UserIcons/HRMS_2e961763-2baf-4207-b360-a33db338d7fa.png', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (2071, 2064, N'dsf', N'1234567890', N'test@test.co', N'M         ', CAST(N'1992-12-12 00:00:00.000' AS DateTime), N'', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (2072, 2065, N'Arya Stark', N'9876543210', N'araya.stark@got.com', N'F         ', CAST(N'1998-02-03 00:00:00.000' AS DateTime), N'../Content/UserIcons/HRMS_4b0bfb16-8822-44ac-8663-d042df00454d.jpg', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (2073, 2066, N'Daenerys Targaryen', N'9998908989', N'danerys.targaryn@got.com', N'F         ', CAST(N'1988-01-19 00:00:00.000' AS DateTime), N'../Content/UserIcons/HRMS_ff8f2dff-f8a8-4501-a5cf-03e44101d495.jpg', 1)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (2074, 2067, N'Jon Snow', N'9876543210', N'jon.snow@got.com', N'M         ', CAST(N'1987-01-14 00:00:00.000' AS DateTime), N'../Content/UserIcons/HRMS_343dcf3e-2f6c-4489-9874-957c7a454e61.jpg', 1)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (2075, 2068, N'Sansa Stark', N'9876543210', N'sansa.stark@got.com', N'F         ', CAST(N'1988-01-27 00:00:00.000' AS DateTime), N'../Content/UserIcons/HRMS_ab86e6bb-81b3-403f-959c-771fb3b111e6.jpg', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (2076, 2069, N'Cersei Lannister', N'9878878898', N'cersei.lannister@got.com', N'F         ', CAST(N'1982-05-28 00:00:00.000' AS DateTime), N'../Content/UserIcons/HRMS_3950bcc3-3753-4ecb-9c89-5a748a29de9d.jpg', 1)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (2077, 2070, N'Catelyn Stark', N'9878878898', N'Catelyn.stark@got.com', N'F         ', CAST(N'1982-05-28 00:00:00.000' AS DateTime), N'../Content/UserIcons/HRMS_be906d5f-5268-456a-9ade-d4a61f91339a.jpg', 1)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (2078, 2071, N'Robb Stark', N'9878878898', N'Robb.stark@got.com', N'M         ', CAST(N'1992-05-28 00:00:00.000' AS DateTime), N'../Content/UserIcons/HRMS_398a03db-0529-41c9-b605-e5d0644c6aeb.jpg', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (2079, 2072, N'Bran Stark', N'9876543210', N'Bran.Stark@got.com', N'M         ', CAST(N'1995-01-03 00:00:00.000' AS DateTime), N'../Content/UserIcons/HRMS_a7f5fa6c-66e6-4529-aa4c-4a4a9c711efe.jpeg', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (2080, 2073, N'Hhd', N'9876543210', N'test@test.co', N'M         ', CAST(N'1992-01-16 00:00:00.000' AS DateTime), N'../Content/UserIcons/HRMS_35501f5b-c56b-44e2-a65b-105627ea77f7.jpg', 1)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (3073, 3066, N'Sijith O S', N'9878878898', N'sijith.os@gmail.com', N'M         ', CAST(N'1992-05-25 00:00:00.000' AS DateTime), N'../Content/UserIcons/HRMS_64fd7990-f4a1-4a62-93a1-33e198519adb.jpg', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (3074, 3067, N'George ', N'8999999000', N'george@comoany.com', N'M         ', CAST(N'1992-01-16 00:00:00.000' AS DateTime), N'', 1)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (3075, 3068, N'Parvan P', N'9876543210', N'parvanp36@gmail.com', N'M         ', CAST(N'1992-08-19 00:00:00.000' AS DateTime), N'', 2)
INSERT [dbo].[EmployeeInfo] ([ID], [EmpId], [EmpName], [EmpPhone], [EmpEmail], [EmpGender], [EmpDob], [EmpPhotoPath], [EmpDesignation]) VALUES (3077, 3070, N'Chain Smokers', N'9876543210', N'csmokers@gmail.com', N'M         ', CAST(N'1992-08-19 00:00:00.000' AS DateTime), N'', 1)
SET IDENTITY_INSERT [dbo].[EmployeeInfo] OFF
SET IDENTITY_INSERT [dbo].[EmployeeLeaveInfo] ON 

INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (16, 8, CAST(N'2016-07-01 00:00:00.000' AS DateTime), CAST(N'2016-07-01 00:00:00.000' AS DateTime), 1, -1, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (17, 8, CAST(N'2016-07-05 00:00:00.000' AS DateTime), CAST(N'2016-07-05 00:00:00.000' AS DateTime), 1, 2, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (19, 8, CAST(N'2016-07-08 00:00:00.000' AS DateTime), CAST(N'2016-07-08 00:00:00.000' AS DateTime), 1, -1, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (23, 8, CAST(N'2016-06-29 00:00:00.000' AS DateTime), CAST(N'2016-06-30 00:00:00.000' AS DateTime), 1, -1, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (24, 8, CAST(N'2016-07-02 00:00:00.000' AS DateTime), CAST(N'2016-07-03 00:00:00.000' AS DateTime), 1, -1, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (25, 8, CAST(N'2016-06-27 00:00:00.000' AS DateTime), CAST(N'2016-06-27 00:00:00.000' AS DateTime), 2, -1, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (26, 8, CAST(N'2016-06-26 00:00:00.000' AS DateTime), CAST(N'2016-06-26 00:00:00.000' AS DateTime), 5, -1, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (27, 9, CAST(N'2016-07-01 00:00:00.000' AS DateTime), CAST(N'2016-07-01 00:00:00.000' AS DateTime), 1, -1, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (28, 9, CAST(N'2016-07-04 00:00:00.000' AS DateTime), CAST(N'2016-07-06 00:00:00.000' AS DateTime), 1, 2, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (29, 8, CAST(N'2016-07-25 00:00:00.000' AS DateTime), CAST(N'2016-07-25 00:00:00.000' AS DateTime), 1, -1, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (30, 8, CAST(N'2016-07-06 00:00:00.000' AS DateTime), CAST(N'2016-07-06 00:00:00.000' AS DateTime), 5, 2, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (31, 9, CAST(N'2016-07-06 00:00:00.000' AS DateTime), CAST(N'2016-07-06 00:00:00.000' AS DateTime), 1, -1, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (1030, 8, CAST(N'2016-07-01 00:00:00.000' AS DateTime), CAST(N'2016-07-02 00:00:00.000' AS DateTime), 2, 2, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (1031, 8, CAST(N'2016-07-21 00:00:00.000' AS DateTime), CAST(N'2016-07-22 00:00:00.000' AS DateTime), 1, 2, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (1032, 8, CAST(N'2016-07-15 00:00:00.000' AS DateTime), CAST(N'2016-07-29 00:00:00.000' AS DateTime), 1, -1, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (1033, 8, CAST(N'2016-07-02 00:00:00.000' AS DateTime), CAST(N'2016-07-02 00:00:00.000' AS DateTime), 1, 2, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (1034, 9, CAST(N'2016-07-02 00:00:00.000' AS DateTime), CAST(N'2016-07-23 00:00:00.000' AS DateTime), 1, -1, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (1035, 9, CAST(N'2016-07-21 00:00:00.000' AS DateTime), CAST(N'2016-07-21 00:00:00.000' AS DateTime), 1, 2, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (1038, 9, CAST(N'2016-08-01 00:00:00.000' AS DateTime), CAST(N'2016-08-05 00:00:00.000' AS DateTime), 1, -1, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (1039, 19, CAST(N'2016-08-01 00:00:00.000' AS DateTime), CAST(N'2016-08-03 00:00:00.000' AS DateTime), 1, -1, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (1040, 8, CAST(N'2016-08-02 00:00:00.000' AS DateTime), CAST(N'2016-08-02 00:00:00.000' AS DateTime), 1, 2, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (1041, 11, CAST(N'2016-08-01 00:00:00.000' AS DateTime), CAST(N'2016-08-02 00:00:00.000' AS DateTime), 1, -1, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (1042, 9, CAST(N'2016-08-06 00:00:00.000' AS DateTime), CAST(N'2016-08-06 00:00:00.000' AS DateTime), 2, 2, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (1043, 8, CAST(N'2016-08-17 00:00:00.000' AS DateTime), CAST(N'2016-08-21 00:00:00.000' AS DateTime), 1, 2, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (1044, 1031, CAST(N'2016-08-10 00:00:00.000' AS DateTime), CAST(N'2016-08-12 00:00:00.000' AS DateTime), 5, -1, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (1045, 1031, CAST(N'2016-08-03 00:00:00.000' AS DateTime), CAST(N'2016-08-10 00:00:00.000' AS DateTime), 2, 2, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (1047, 1031, CAST(N'2016-08-17 00:00:00.000' AS DateTime), CAST(N'2016-08-17 00:00:00.000' AS DateTime), 2, 2, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (1048, 1031, CAST(N'2016-08-01 00:00:00.000' AS DateTime), CAST(N'2016-08-30 00:00:00.000' AS DateTime), 1, 2, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (1052, 9, CAST(N'2016-09-01 00:00:00.000' AS DateTime), CAST(N'2016-09-01 00:00:00.000' AS DateTime), 1, 2, N'bc', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2052, 8, CAST(N'2016-09-14 00:00:00.000' AS DateTime), CAST(N'2016-09-14 00:00:00.000' AS DateTime), 5, 3, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2053, 8, CAST(N'2016-09-08 00:00:00.000' AS DateTime), CAST(N'2016-09-08 00:00:00.000' AS DateTime), 1, -1, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2054, 8, CAST(N'2016-09-07 00:00:00.000' AS DateTime), CAST(N'2016-09-07 00:00:00.000' AS DateTime), 5, -1, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2055, 1031, CAST(N'2016-09-14 00:00:00.000' AS DateTime), CAST(N'2016-09-14 00:00:00.000' AS DateTime), 5, 2, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2056, 8, CAST(N'2016-09-08 00:00:00.000' AS DateTime), CAST(N'2016-09-08 00:00:00.000' AS DateTime), 5, -1, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2057, 8, CAST(N'2016-09-09 00:00:00.000' AS DateTime), CAST(N'2016-09-09 00:00:00.000' AS DateTime), 1, 2, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2058, 8, CAST(N'2016-09-30 00:00:00.000' AS DateTime), CAST(N'2016-09-30 00:00:00.000' AS DateTime), 1, 2, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2059, 8, CAST(N'2016-09-09 00:00:00.000' AS DateTime), CAST(N'2016-09-09 00:00:00.000' AS DateTime), 5, -1, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2060, 8, CAST(N'2016-09-29 00:00:00.000' AS DateTime), CAST(N'2016-09-29 00:00:00.000' AS DateTime), 5, -1, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2061, 8, CAST(N'2016-08-28 00:00:00.000' AS DateTime), CAST(N'2016-08-28 00:00:00.000' AS DateTime), 5, 2, N'sadf', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2062, 8, CAST(N'2016-09-14 00:00:00.000' AS DateTime), CAST(N'2016-09-14 00:00:00.000' AS DateTime), 5, 3, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2063, 8, CAST(N'2016-09-07 00:00:00.000' AS DateTime), CAST(N'2016-09-07 00:00:00.000' AS DateTime), 5, 3, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2064, 8, CAST(N'2016-10-01 00:00:00.000' AS DateTime), CAST(N'2016-10-01 00:00:00.000' AS DateTime), 5, 3, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2065, 8, CAST(N'2016-10-07 00:00:00.000' AS DateTime), CAST(N'2016-10-07 00:00:00.000' AS DateTime), 5, 3, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2067, 9, CAST(N'2016-09-01 00:00:00.000' AS DateTime), CAST(N'2016-09-01 00:00:00.000' AS DateTime), 2, 3, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2068, 9, CAST(N'2016-09-02 00:00:00.000' AS DateTime), CAST(N'2016-09-02 00:00:00.000' AS DateTime), 2, 3, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2069, 9, CAST(N'2016-09-09 00:00:00.000' AS DateTime), CAST(N'2016-09-09 00:00:00.000' AS DateTime), 5, 3, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2070, 9, CAST(N'2016-06-01 00:00:00.000' AS DateTime), CAST(N'2016-06-02 00:00:00.000' AS DateTime), 5, 3, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2071, 9, CAST(N'2016-09-21 00:00:00.000' AS DateTime), CAST(N'2016-09-21 00:00:00.000' AS DateTime), 5, 3, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2072, 9, CAST(N'2016-09-23 00:00:00.000' AS DateTime), CAST(N'2016-09-23 00:00:00.000' AS DateTime), 5, 3, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2073, 9, CAST(N'2016-09-30 00:00:00.000' AS DateTime), CAST(N'2016-09-30 00:00:00.000' AS DateTime), 5, -1, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2082, 8, CAST(N'2016-09-25 00:00:00.000' AS DateTime), CAST(N'2016-09-25 00:00:00.000' AS DateTime), 5, 3, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2083, 8, CAST(N'2016-09-29 00:00:00.000' AS DateTime), CAST(N'2016-09-29 00:00:00.000' AS DateTime), 5, 3, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2084, 8, CAST(N'2016-10-07 00:00:00.000' AS DateTime), CAST(N'2016-10-07 00:00:00.000' AS DateTime), 5, 2, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2085, 8, CAST(N'2016-09-14 00:00:00.000' AS DateTime), CAST(N'2016-09-14 00:00:00.000' AS DateTime), 2, 3, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2086, 8, CAST(N'2016-09-27 00:00:00.000' AS DateTime), CAST(N'2016-09-27 00:00:00.000' AS DateTime), 2, 3, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2087, 8, CAST(N'2016-09-28 00:00:00.000' AS DateTime), CAST(N'2016-09-28 00:00:00.000' AS DateTime), 5, 3, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2088, 8, CAST(N'2016-09-01 00:00:00.000' AS DateTime), CAST(N'2016-09-01 00:00:00.000' AS DateTime), 5, 3, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2089, 8, CAST(N'2016-09-28 00:00:00.000' AS DateTime), CAST(N'2016-09-28 00:00:00.000' AS DateTime), 2, 2, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2090, 9, CAST(N'2016-09-28 00:00:00.000' AS DateTime), CAST(N'2016-09-28 00:00:00.000' AS DateTime), 2, 3, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2091, 9, CAST(N'2016-09-28 00:00:00.000' AS DateTime), CAST(N'2016-09-28 00:00:00.000' AS DateTime), 5, 3, N'dcfs', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2092, 8, CAST(N'2016-10-01 00:00:00.000' AS DateTime), CAST(N'2016-10-01 00:00:00.000' AS DateTime), 2, 3, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2093, 1031, CAST(N'2016-10-04 00:00:00.000' AS DateTime), CAST(N'2016-10-04 00:00:00.000' AS DateTime), 5, 3, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2094, 8, CAST(N'2016-10-05 00:00:00.000' AS DateTime), CAST(N'2016-10-05 00:00:00.000' AS DateTime), 5, 3, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2095, 8, CAST(N'2016-10-06 00:00:00.000' AS DateTime), CAST(N'2016-10-06 00:00:00.000' AS DateTime), 2, -1, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (2096, 9, CAST(N'2016-10-05 00:00:00.000' AS DateTime), CAST(N'2016-10-05 00:00:00.000' AS DateTime), 2, 3, N'oiuio', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (3094, 9, CAST(N'2016-12-26 00:00:00.000' AS DateTime), CAST(N'2016-12-26 00:00:00.000' AS DateTime), 2, 2, N'happy xms', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (3095, 9, CAST(N'2016-10-01 00:00:00.000' AS DateTime), CAST(N'2016-10-01 00:00:00.000' AS DateTime), 5, 2, N'''jh''', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (3096, 8, CAST(N'2016-10-19 00:00:00.000' AS DateTime), CAST(N'2016-10-19 00:00:00.000' AS DateTime), 5, 2, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4094, 8, CAST(N'2016-10-01 00:00:00.000' AS DateTime), CAST(N'2016-10-03 00:00:00.000' AS DateTime), 2, 2, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4095, 9, CAST(N'2016-10-26 00:00:00.000' AS DateTime), CAST(N'2016-10-26 00:00:00.000' AS DateTime), 5, 2, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4096, 9, CAST(N'2016-10-26 00:00:00.000' AS DateTime), CAST(N'2016-10-26 00:00:00.000' AS DateTime), 2, 2, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4098, 8, CAST(N'2016-10-26 00:00:00.000' AS DateTime), CAST(N'2016-10-26 00:00:00.000' AS DateTime), 5, -1, N's', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4099, 8, CAST(N'2016-10-27 00:00:00.000' AS DateTime), CAST(N'2016-10-27 00:00:00.000' AS DateTime), 5, -1, N'ww', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4100, 9, CAST(N'2016-10-27 00:00:00.000' AS DateTime), CAST(N'2016-10-27 00:00:00.000' AS DateTime), 5, 3, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4101, 9, CAST(N'2016-10-28 00:00:00.000' AS DateTime), CAST(N'2016-10-28 00:00:00.000' AS DateTime), 5, 3, N'fever.', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4102, 8, CAST(N'2016-10-27 00:00:00.000' AS DateTime), CAST(N'2016-10-28 00:00:00.000' AS DateTime), 5, 3, N'dsad', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4103, 9, CAST(N'2016-10-28 00:00:00.000' AS DateTime), CAST(N'2016-10-28 00:00:00.000' AS DateTime), 2, 3, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4104, 9, CAST(N'2016-10-29 00:00:00.000' AS DateTime), CAST(N'2016-11-05 00:00:00.000' AS DateTime), 5, 3, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4105, 9, CAST(N'2016-10-30 00:00:00.000' AS DateTime), CAST(N'2016-10-31 00:00:00.000' AS DateTime), 2, 3, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4106, 9, CAST(N'2016-11-01 00:00:00.000' AS DateTime), CAST(N'2016-11-01 00:00:00.000' AS DateTime), 5, 3, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4107, 9, CAST(N'2016-11-02 00:00:00.000' AS DateTime), CAST(N'2016-11-02 00:00:00.000' AS DateTime), 5, 3, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4108, 9, CAST(N'2016-11-02 00:00:00.000' AS DateTime), CAST(N'2016-11-02 00:00:00.000' AS DateTime), 5, 3, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4109, 9, CAST(N'2016-11-02 00:00:00.000' AS DateTime), CAST(N'2016-11-02 00:00:00.000' AS DateTime), 5, 2, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4110, 9, CAST(N'2016-11-04 00:00:00.000' AS DateTime), CAST(N'2016-11-04 00:00:00.000' AS DateTime), 1, 2, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4111, 9, CAST(N'2016-11-08 00:00:00.000' AS DateTime), CAST(N'2016-11-08 00:00:00.000' AS DateTime), 5, -1, N'v', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4112, 9, CAST(N'2016-11-09 00:00:00.000' AS DateTime), CAST(N'2016-11-09 00:00:00.000' AS DateTime), 2, 2, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4113, 9, CAST(N'2016-11-02 00:00:00.000' AS DateTime), CAST(N'2016-11-02 00:00:00.000' AS DateTime), 2, 2, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4114, 9, CAST(N'2016-11-03 00:00:00.000' AS DateTime), CAST(N'2016-11-03 00:00:00.000' AS DateTime), 5, 2, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4115, 9, CAST(N'2016-11-24 00:00:00.000' AS DateTime), CAST(N'2016-11-24 00:00:00.000' AS DateTime), 5, -1, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4116, 8, CAST(N'2016-11-23 00:00:00.000' AS DateTime), CAST(N'2016-11-23 00:00:00.000' AS DateTime), 5, -1, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4117, 8, CAST(N'2016-11-25 00:00:00.000' AS DateTime), CAST(N'2016-11-25 00:00:00.000' AS DateTime), 5, 2, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4118, 8, CAST(N'2016-11-02 00:00:00.000' AS DateTime), CAST(N'2016-11-02 00:00:00.000' AS DateTime), 5, 2, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4119, 9, CAST(N'2016-11-15 00:00:00.000' AS DateTime), CAST(N'2016-11-15 00:00:00.000' AS DateTime), 5, 3, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4121, 9, CAST(N'2016-11-16 00:00:00.000' AS DateTime), CAST(N'2016-11-16 00:00:00.000' AS DateTime), 2, -1, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4122, 9, CAST(N'2016-11-17 00:00:00.000' AS DateTime), CAST(N'2016-11-17 00:00:00.000' AS DateTime), 2, 2, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4123, 9, CAST(N'2016-11-18 00:00:00.000' AS DateTime), CAST(N'2016-11-18 00:00:00.000' AS DateTime), 2, -1, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4124, 9, CAST(N'2016-11-21 00:00:00.000' AS DateTime), CAST(N'2016-11-21 00:00:00.000' AS DateTime), 5, 1, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4125, 9, CAST(N'2016-11-22 00:00:00.000' AS DateTime), CAST(N'2016-11-22 00:00:00.000' AS DateTime), 5, 2, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4126, 9, CAST(N'2016-11-21 00:00:00.000' AS DateTime), CAST(N'2016-11-21 00:00:00.000' AS DateTime), 5, 2, N'', N'Half Day')
GO
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4127, 8, CAST(N'2016-11-16 00:00:00.000' AS DateTime), CAST(N'2016-11-16 00:00:00.000' AS DateTime), 5, 3, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4128, 8, CAST(N'2016-11-16 00:00:00.000' AS DateTime), CAST(N'2016-11-16 00:00:00.000' AS DateTime), 5, 2, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4129, 8, CAST(N'2016-11-17 00:00:00.000' AS DateTime), CAST(N'2016-11-17 00:00:00.000' AS DateTime), 2, 1, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (4130, 8, CAST(N'2016-11-02 00:00:00.000' AS DateTime), CAST(N'2016-11-02 00:00:00.000' AS DateTime), 5, -1, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (5130, 9, CAST(N'2016-12-01 00:00:00.000' AS DateTime), CAST(N'2016-12-01 00:00:00.000' AS DateTime), 5, 3, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (5133, 8, CAST(N'2016-12-05 00:00:00.000' AS DateTime), CAST(N'2016-12-05 00:00:00.000' AS DateTime), 5, -1, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (7189, 20, CAST(N'2016-12-29 00:00:00.000' AS DateTime), CAST(N'2017-01-03 00:00:00.000' AS DateTime), 1, 2, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (7190, 20, CAST(N'2017-01-20 00:00:00.000' AS DateTime), CAST(N'2017-01-20 00:00:00.000' AS DateTime), 5, 2, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (7191, 9, CAST(N'2017-01-16 00:00:00.000' AS DateTime), CAST(N'2017-01-16 00:00:00.000' AS DateTime), 1, 2, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (7192, 9, CAST(N'2017-01-20 00:00:00.000' AS DateTime), CAST(N'2017-01-20 00:00:00.000' AS DateTime), 5, 2, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (7193, 9, CAST(N'2017-01-26 00:00:00.000' AS DateTime), CAST(N'2017-01-26 00:00:00.000' AS DateTime), 2, 2, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (7194, 9, CAST(N'2017-01-19 00:00:00.000' AS DateTime), CAST(N'2017-01-19 00:00:00.000' AS DateTime), 1, 3, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (8152, 11, CAST(N'2016-12-29 00:00:00.000' AS DateTime), CAST(N'2017-01-03 00:00:00.000' AS DateTime), 1, 3, N'nbhjjh', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (8153, 20, CAST(N'2017-01-23 00:00:00.000' AS DateTime), CAST(N'2017-01-23 00:00:00.000' AS DateTime), 1, -1, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (8154, 9, CAST(N'2017-01-24 00:00:00.000' AS DateTime), CAST(N'2017-01-24 00:00:00.000' AS DateTime), 5, -1, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (8155, 9, CAST(N'2017-01-24 00:00:00.000' AS DateTime), CAST(N'2017-01-24 00:00:00.000' AS DateTime), 5, 1, N'', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (8156, 2065, CAST(N'2017-01-24 00:00:00.000' AS DateTime), CAST(N'2017-01-24 00:00:00.000' AS DateTime), 1, 3, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (8157, 9, CAST(N'2017-01-24 00:00:00.000' AS DateTime), CAST(N'2017-01-24 00:00:00.000' AS DateTime), 1, 1, N'', N'Half Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (8158, 2069, CAST(N'2017-01-25 00:00:00.000' AS DateTime), CAST(N'2017-01-25 00:00:00.000' AS DateTime), 1, 2, N'to kill the priests.', N'Full Day')
INSERT [dbo].[EmployeeLeaveInfo] ([Id], [EmpId], [FromDate], [ToDate], [LeaveType], [Status], [Comments], [DurationType]) VALUES (9158, 3066, CAST(N'2017-01-30 00:00:00.000' AS DateTime), CAST(N'2017-01-30 00:00:00.000' AS DateTime), 1, 1, N'', N'Full Day')
SET IDENTITY_INSERT [dbo].[EmployeeLeaveInfo] OFF
SET IDENTITY_INSERT [dbo].[HrmsQuery] ON 

INSERT [dbo].[HrmsQuery] ([ID], [QuerySubject], [QueryBody], [Date], [IsRead], [EmpId]) VALUES (1, N'Query From HRMS : Query', N'Query from the User Test User (MailId nithinvelluva@gmail.com)
immediate action', CAST(N'2016-07-01 11:34:51.000' AS DateTime), 0, 9)
INSERT [dbo].[HrmsQuery] ([ID], [QuerySubject], [QueryBody], [Date], [IsRead], [EmpId]) VALUES (2, N'Query From HRMS : dg', N'Query from the User Nithin N (MailId nithinvelluva@gmail.com)
df', CAST(N'2016-07-04 15:36:12.000' AS DateTime), 0, 9)
INSERT [dbo].[HrmsQuery] ([ID], [QuerySubject], [QueryBody], [Date], [IsRead], [EmpId]) VALUES (3, N'Query From HRMS : sad', N'Query from the User Test User (MailId nithinvelluva@gmail.com)
asd', CAST(N'2016-09-08 15:40:21.000' AS DateTime), 0, 9)
INSERT [dbo].[HrmsQuery] ([ID], [QuerySubject], [QueryBody], [Date], [IsRead], [EmpId]) VALUES (4, N'Query From HRMS : wq', N'Query from the User Nithin N (MailId nithinvelluva@gmail.com)
sqs', CAST(N'2016-10-26 10:27:55.000' AS DateTime), 0, 9)
INSERT [dbo].[HrmsQuery] ([ID], [QuerySubject], [QueryBody], [Date], [IsRead], [EmpId]) VALUES (5, N'Query From HRMS : qwe', N'Query from the User Nithin N (MailId nithinvelluva@gmail.com)
we', CAST(N'2016-10-26 10:30:54.000' AS DateTime), 0, 9)
INSERT [dbo].[HrmsQuery] ([ID], [QuerySubject], [QueryBody], [Date], [IsRead], [EmpId]) VALUES (6, N'Query From HRMS : we', N'Query from the User Nithin N (MailId nithinvelluva@gmail.com)
ew', CAST(N'2016-11-21 18:30:04.000' AS DateTime), 0, 9)
INSERT [dbo].[HrmsQuery] ([ID], [QuerySubject], [QueryBody], [Date], [IsRead], [EmpId]) VALUES (7, N'Query From HRMS : d', N'Query from the User Nithin N (MailId nithinvelluva@gmail.com)
dsa', CAST(N'2016-11-22 12:20:17.000' AS DateTime), 0, 9)
INSERT [dbo].[HrmsQuery] ([ID], [QuerySubject], [QueryBody], [Date], [IsRead], [EmpId]) VALUES (8, N'Query From HRMS : sdcds', N'Query from the User Jiffy Kuriakose (MailId jiffy@grindan.com)
df', CAST(N'2017-01-23 10:43:28.000' AS DateTime), 0, 20)
SET IDENTITY_INSERT [dbo].[HrmsQuery] OFF
SET IDENTITY_INSERT [dbo].[LeaveStatistics] ON 

INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (1008, 8, 0, 0, 0.5, 0, 2016)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (1009, 9, 0, 0, 5, 0, 2016)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (1011, 11, 24, 9, 14, 0, 2016)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (1019, 19, 24.5, 9, 14, 0, 2016)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (1020, 20, 29, 9, 14, 0, 2016)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (2019, 1019, 30, 9, 14, 0, 2016)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (2024, 1024, 30, 9, 14, 0, 2016)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (2025, 1025, 30, 9, 14, 0, 2016)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (2026, 1026, 30, 9, 14, 0, 2016)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (2031, 1031, 0, 0, 10, 0, 2016)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (2041, 1041, 30, 9, 14, 0, 2016)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (2042, 1042, 30, 9, 14, 0, 2016)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (2044, 1044, 30, 9, 14, 0, 2016)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (2045, 1045, 30, 9, 14, 0, 2016)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (3045, 2045, 30, 9, 14, 0, 2016)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (3046, 2046, 30, 9, 14, 0, 2016)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (3048, 2048, 30, 9, 14, 0, 2016)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (3049, 2049, 30, 9, 14, 0, 2016)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (3051, 2051, 30, 9, 14, 0, 2016)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (3052, 2052, 30, 9, 14, 0, 2016)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (3053, 2053, 30, 9, 14, 0, 2016)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (3054, 2054, 30, 9, 14, 0, 2016)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (3057, 2057, 30, 9, 14, 0, 2016)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (3058, 2058, 30, 9, 14, 0, 2016)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (3060, 2060, 30, 9, 14, 0, 2016)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (3062, 2062, 30, 9, 14, 0, 2016)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (3063, 2063, 30, 9, 14, 0, 2016)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (3064, 2064, 30, 9, 14, 0, 2016)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (251953, 8, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (251954, 9, 28.5, 8, 12, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (251955, 11, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (251956, 19, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (251957, 20, 29, 9, 13, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (251958, 1019, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (251959, 1024, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (251960, 1025, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (251961, 1026, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (251962, 1031, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (251963, 1041, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (251964, 1042, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (251965, 1044, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (251966, 1045, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (251967, 2045, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (251968, 2046, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (251969, 2048, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (251970, 2049, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (251971, 2051, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (251972, 2052, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (251973, 2053, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (251974, 2054, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (251975, 2057, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (251976, 2058, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (251977, 2060, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (251978, 2062, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (251979, 2063, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (251980, 2064, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (252953, 2065, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (252954, 2066, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (252955, 2067, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (252956, 2068, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (252957, 2069, 29, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (252958, 2070, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (252959, 2071, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (252960, 2072, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (252961, 2073, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (253954, 3066, 29, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (253955, 3067, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (253956, 3068, 30, 9, 14, 0, 2017)
INSERT [dbo].[LeaveStatistics] ([Id], [EmpId], [CasualLeave], [FestiveLeave], [SickLeave], [LossOfPay], [Year]) VALUES (253958, 3070, 30, 9, 14, 0, 2017)
SET IDENTITY_INSERT [dbo].[LeaveStatistics] OFF
SET IDENTITY_INSERT [dbo].[LeaveType] ON 

INSERT [dbo].[LeaveType] ([Id], [Type], [Count]) VALUES (1, N'Casual    ', 30)
INSERT [dbo].[LeaveType] ([Id], [Type], [Count]) VALUES (2, N'Festive   ', 9)
INSERT [dbo].[LeaveType] ([Id], [Type], [Count]) VALUES (5, N'Sick      ', 14)
SET IDENTITY_INSERT [dbo].[LeaveType] OFF
SET IDENTITY_INSERT [dbo].[UserInfo] ON 

INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (7, N'admin', N'MIhjGZU1/xBQdJMwd8IUbbApNR3+dBEYa0DeZx3soMYEpaCI', 1)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (8, N'test', N'sbvwVSzI/VlCpMDBbx1o4noEMPd22jyjELw1Dv2uWcYrlFAY', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (9, N'nithin', N'q45l/fGU8T9D6ZljyjdtbhQPmgtcMeFtIUS84jrAsKe+aFyR', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (11, N'rahul', N'QdxsKjURM+wFfVqBjRfIPuRSOCgoMpBfU3WdUPW/XqPxCfPN', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (19, N'faizal', N'CbGiDiIUKbteYGvr/e8vN/MDPJ42gD0KnFsddec1y0ogxWb5', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (20, N'jiffy', N'6syAqzUuC71cFee/CIYgI/HJL2u8a2vtoRxoGtObFX2eptAW', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (1019, N'mohith', N'vOQ45G/d4UiBd2BpBW1Lur3q3A83lSN/cDqPc9jES7EepAQW', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (1024, N'anusree', N'uoX2AbV7FnasjoLto4GO1dYLgilya0fRJ/zEBc1NTpqB+l5s', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (1025, N'annie.manu', N'rPzlI+QM4t45cucOIr34MHd9Yh4w9afbI1qldPOjQlrBqeys', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (1026, N'anil', N'rmx1SdTPXjmVmgdV0scPMQc1sjhzZRVgo38RTE1aFWMHftoR', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (1031, N'bibin', N'lktCBbvhIbQtN7E2Gl6wkpmx9y9nJqbj9BpD19vH9o2SCrnK', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (1041, N'Sachin', N'+fMJ1avUp7VrWtyN92ABMOMmRw60m7bP1Y2aXiNtHm+JpkVp', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (1042, N'Sehwag ', N'TDuJ0dpyBBZXasBQJxs04e60JUFEXYZCjyFnGWzCLtZMntPZ', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (1044, N'tom.cruise', N'RMEK8zZjtt5eJZ8Ke4TB0RJJ64bsjGmVjoNT9ODpUpRXN1m9', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (1045, N'gangully.h', N'fIRG4s2796xBc9j3JjvVFsIoDMYdataeRbQbEvUnHwJLe0ll', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (2045, N'sad', N'1GWNVuRAmSrnowWNa8EaZnl8XRYUgT8Rep3Ykf0LifBex1gx', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (2046, N'qwerty', N'+OdxCQRuC9kcKBPe4LLUhsnGVEKWstBEgOQOtOPptBdevVlX', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (2048, N'qwerty.123', N'Y+0iAZ3uT06md1tEAScpWYJt+rSa0RpZtw6kWDE6fmpTY9Sd', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (2049, N'hari.123', N'a44EZej6wEmLcsNOMLCtyYH0rIzXJNYQOtRwAbPM+Z8+uhF7', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (2051, N'andrew', N'VQjgCQGocIfL9/6BJGrtCufcEW8XVDmCmdO3jifLNf/n1Fv+', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (2052, N't@d.in', N'ryyW+hrtPJrgCByPAwnBa9CpGhlD9XY7SvJk+Xw1+B9VOv5g', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (2053, N'q', N'PCBREkPw/6Ku26w9n3FJgvL9BV8zIxhShtnP2zF5l1hf/ts8', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (2054, N'a', N'y9x+fkLFyJ3C56CUQMlc9wj9NIoaqprzOEmlU08zv+mTWXSg', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (2057, N'SA', N'cQ4G0+UzdTJIE+uG6oTkKJH+Vlb48NN60jWYa6pcDKKWgOJQ', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (2058, N'aWSQE', N'tf3xS5Z+YxeKBypaO4I6M6g2gMT1PEE0kgptj6dRiMw0zgM5', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (2060, N'adminASA', N'210y8ayV/DD/G2oujSPNaxbHRcx74SeOK3X3WRR344iZmOhN', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (2062, N'nithin.123', N'x0NwXKnQ6PnugjQu/1TtU5P/gvSXdwGlXVVSDkGCaTl8sLbp', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (2063, N'raghav', N'O94sTJZyAaplXbJsNsd6s53S16sZto2CfIr02KcKNLqd1MYh', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (2064, N'admin@123', N'u7HsShzYUa+gHW2C/Je0eIJ7lB3ZL+Dy8mazO0D5Phf5A61N', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (2065, N'arya', N'0NrLYiITSNYlZjNLlsifM3sKaoZMBaNqMW0VaF5STnhjfuqh', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (2066, N'danerys', N'7ATF6fs2a1zavgF/PFrQkh6CAuyYC4s/1zAn+BNOMhPPJ+lR', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (2067, N'jonsnow', N'H8TfWswglChQd9+Dph5RbnpTHdx53W3slpukIpLzALfGZmNG', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (2068, N'sansastark', N'BnZCe2c4JCA0AO3nZXhnuTBFuDVDaac+7vz4aCfxxjEjzRFS', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (2069, N'cersei', N'7lerz8jILlTxjciDSl0fkH5e4E8ZoKOn8J2ZqUxEqjybNRiK', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (2070, N'catelyn', N'9Pr3Qm1LhcXK9bzUivqmeYoLkD/AOD9KmPnl2F9pn1YEnO00', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (2071, N'Robb', N'C2RPUcmmWLlz/gS+dJVidHdR4JdqecumabZY9MMYTM1SSTS+', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (2072, N'branstark', N'OH1ojdw/l7p0LTYjCD0eIhVSUHbadgI73CAzHe6PJleztydX', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (2073, N'Dinkiri', N'MkuHnyrQLgCqDeprAIn9tDIELAhfstT8aLlX3F9E4pC73F97', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (3066, N'sijith.os', N'MCq7S8W68VXiDNNuSdHfeANela6vGvLhVWGngqBwPacidjsP', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (3067, N'george', N'St8p7PcKxvpYcpdDwVy9MHeUlKYmzjCJyZv7rk2+UHQ4n24U', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (3068, N'parvanp', N'HCzsE9PmQXWE7PWhH6eJEuRTo5/4sS7Ue0u2VKPUk2MwLgO6', 2)
INSERT [dbo].[UserInfo] ([ID], [UserName], [Password], [UserType]) VALUES (3070, N'csmokers', N'sMQ+un563VUEdawLQzDHQbOknQ+lne70+PdSeNi0UD9zet8/', 2)
SET IDENTITY_INSERT [dbo].[UserInfo] OFF
SET IDENTITY_INSERT [dbo].[UserPrivilages] ON 

INSERT [dbo].[UserPrivilages] ([Id], [Privilage]) VALUES (1, N'ADMIN     ')
INSERT [dbo].[UserPrivilages] ([Id], [Privilage]) VALUES (2, N'USER      ')
SET IDENTITY_INSERT [dbo].[UserPrivilages] OFF
ALTER TABLE [dbo].[Attendance]  WITH CHECK ADD FOREIGN KEY([EmpId])
REFERENCES [dbo].[EmployeeInfo] ([EmpId])
GO
ALTER TABLE [dbo].[EmployeeInfo]  WITH CHECK ADD FOREIGN KEY([EmpDesignation])
REFERENCES [dbo].[EmpDesignation] ([ID])
GO
ALTER TABLE [dbo].[EmployeeInfo]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeInfo_UserInfo] FOREIGN KEY([EmpId])
REFERENCES [dbo].[UserInfo] ([ID])
GO
ALTER TABLE [dbo].[EmployeeInfo] CHECK CONSTRAINT [FK_EmployeeInfo_UserInfo]
GO
ALTER TABLE [dbo].[EmployeeLeaveInfo]  WITH CHECK ADD FOREIGN KEY([EmpId])
REFERENCES [dbo].[EmployeeInfo] ([EmpId])
GO
ALTER TABLE [dbo].[EmployeeLeaveInfo]  WITH CHECK ADD FOREIGN KEY([LeaveType])
REFERENCES [dbo].[LeaveType] ([Id])
GO
ALTER TABLE [dbo].[LeaveStatistics]  WITH CHECK ADD FOREIGN KEY([EmpId])
REFERENCES [dbo].[EmployeeInfo] ([EmpId])
GO
ALTER TABLE [dbo].[UserInfo]  WITH CHECK ADD FOREIGN KEY([UserType])
REFERENCES [dbo].[UserPrivilages] ([Id])
GO
/****** Object:  StoredProcedure [dbo].[AddEmployeeReturnID]    Script Date: 2017-02-08 14:32:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddEmployeeReturnID] 
	@FirstName varchar(50),
	@LastName varchar(50),
	@BirthDate datetime,
	@City varchar(50),
	@Country varchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO  Employees (FirstName, LastName, BirthDate, City, Country)
	VALUES (@FirstName, @LastName, @BirthDate, @City, @Country) 
	SELECT SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[AddLeaveInfo]    Script Date: 2017-02-08 14:32:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[AddLeaveInfo]
(
  @count int OUT,
  @loopVar int OUT,
  @i int OUT,
  @casual float OUT,
  @festive float OUT,
  @sick float OUT,
  @year int
)

AS
BEGIN

IF OBJECT_ID('tempdb.dbo.#TempTable', 'U') IS NOT NULL
  DROP TABLE #TempTable;

  CREATE TABLE #TempTable
  (
    ID INT IDENTITY(1, 1) primary key ,
    EmpId INT
  );

INSERT INTO #TempTable SELECT ID FROM UserInfo WHERE UserType != 1 

SELECT @count = COUNT(ID) FROM #TempTable
SELECT @loopVar = 0
SELECT @i = 0

SELECT @casual = Count From LeaveType WHERE Type='Casual'
SELECT @festive = Count From LeaveType WHERE Type='Festive'
SELECT @sick = Count From LeaveType WHERE Type='Sick'

WHILE @loopVar < @count
BEGIN
     SELECT @i = @i + 1

     DECLARE @empid int;
	 SELECT @empid = EmpId from #TempTable where ID = @i	 

	 INSERT into LeaveStatistics(EmpId,CasualLeave,FestiveLeave,SickLeave,LossOfPay,[Year])
	 VALUES(@empid,@casual,@festive,@sick,'0',@year)

	 SELECT @loopVar = @loopVar + 1
END

END





GO
/****** Object:  StoredProcedure [dbo].[InsertEmployeeDetails]    Script Date: 2017-02-08 14:32:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[InsertEmployeeDetails]
(
@empname varchar(10),
@empusername varchar(10),
@emppassword varchar(10),
@empgender varchar(5),
@empphone varchar(10),
@empmail nvarchar(50),
@usertype INT,
@dob DATETIME,
@userphotopath nvarchar(max),
@empid int OUT,
@casual float OUT,
@festive float OUT,
@sick float OUT
)

AS
BEGIN
INSERT INTO RegiInfo(name,uname,pwd,gender,phone,EmailID,UserType,dob,PhotoPath) 
VALUES(@empname,@empusername,@emppassword,@empgender,@empphone,@empmail,@usertype,@dob,@userphotopath)

Select @empid=@@IDENTITY 
select @casual=Count From LeaveType WHERE Type='Casual'
select @festive=Count From LeaveType WHERE Type='Festive'
select @sick=Count From LeaveType WHERE Type='Sick'

INSERT into LeaveStatistics(EmpId,CasualLeave,FestiveLeave,SickLeave,LossOfPay) VALUES(@empid,@casual,@festive,@sick,'0')
END




GO
/****** Object:  StoredProcedure [dbo].[InsertEmployeeDetailsMVC]    Script Date: 2017-02-08 14:32:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[InsertEmployeeDetailsMVC]
(
@empname nvarchar(50),
@empusername varchar(10),
@emppassword nvarchar(max),
@empgender varchar(5),
@empphone varchar(10),
@empmail nvarchar(50),
@usertype INT,
@designation INT,
@empdob DATETIME,
@empphotopath nvarchar(max),
@UserId int OUT,
@empid int OUT,
@casual float OUT,
@festive float OUT,
@sick float OUT,
@year INT OUT
)

AS
BEGIN
INSERT INTO UserInfo([UserName],[Password],[UserType])
VALUES(@empusername,@emppassword,@usertype)

Select @UserId=@@IDENTITY 

INSERT INTO EmployeeInfo([EmpId],[EmpName],[EmpPhone],[EmpEmail],[EmpGender],[EmpDob],[EmpPhotoPath],[EmpDesignation])
VALUES(@UserId,@empname,@empphone,@empmail,@empgender,@empdob,@empphotopath,@designation)

Select @empid=@@IDENTITY 

select @casual=Count From LeaveType WHERE Type='Casual'
select @festive=Count From LeaveType WHERE Type='Festive'
select @sick=Count From LeaveType WHERE Type='Sick'

INSERT into LeaveStatistics(EmpId,CasualLeave,FestiveLeave,SickLeave,LossOfPay,[Year]) VALUES(@UserId,@casual,@festive,@sick,'0',@year)
END





GO
/****** Object:  StoredProcedure [dbo].[RemoveEmployee]    Script Date: 2017-02-08 14:32:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[RemoveEmployee]
(
@empid INT
)
AS
Begin
DELETE FROM Attendance WHERE EmpId=@empid
DELETE FROM EmployeeLeaveInfo WHERE EmpId=@empid
DELETE FROM LeaveStatistics WHERE EmpId=@empid
DELETE FROM HrmsQuery WHERE EmpId=@empid
DELETE FROM EmployeeInfo WHERE EmpId=@empid
DELETE FROM UserInfo WHERE ID=@empid

END


GO
USE [master]
GO
ALTER DATABASE [LoginInfo] SET  READ_WRITE 
GO
