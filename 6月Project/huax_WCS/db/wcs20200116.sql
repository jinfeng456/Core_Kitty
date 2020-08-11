USE [master]
GO
/****** Object:  Database [huax_wcs]    Script Date: 2020/1/16 15:09:07 ******/
CREATE DATABASE [huax_wcs]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'huax_wcs', FILENAME = N'D:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\huax_wcs.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'huax_wcs_log', FILENAME = N'D:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\huax_wcs_log.ldf' , SIZE = 139264KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [huax_wcs].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [huax_wcs] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [huax_wcs] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [huax_wcs] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [huax_wcs] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [huax_wcs] SET ARITHABORT OFF 
GO
ALTER DATABASE [huax_wcs] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [huax_wcs] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [huax_wcs] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [huax_wcs] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [huax_wcs] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [huax_wcs] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [huax_wcs] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [huax_wcs] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [huax_wcs] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [huax_wcs] SET  DISABLE_BROKER 
GO
ALTER DATABASE [huax_wcs] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [huax_wcs] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [huax_wcs] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [huax_wcs] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [huax_wcs] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [huax_wcs] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [huax_wcs] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [huax_wcs] SET RECOVERY FULL 
GO
ALTER DATABASE [huax_wcs] SET  MULTI_USER 
GO
ALTER DATABASE [huax_wcs] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [huax_wcs] SET DB_CHAINING OFF 
GO
ALTER DATABASE [huax_wcs] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [huax_wcs] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [huax_wcs] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'huax_wcs', N'ON'
GO
USE [huax_wcs]
GO
USE [huax_wcs]
GO
/****** Object:  Sequence [dbo].[idSeq]    Script Date: 2020/1/16 15:09:07 ******/
CREATE SEQUENCE [dbo].[idSeq] 
 AS [tinyint]
 START WITH 1
 INCREMENT BY 1
 MINVALUE 0
 MAXVALUE 255
 CACHE 
GO
USE [huax_wcs]
GO
/****** Object:  Sequence [dbo].[sequence_id]    Script Date: 2020/1/16 15:09:07 ******/
CREATE SEQUENCE [dbo].[sequence_id] 
 AS [bigint]
 START WITH 1
 INCREMENT BY 1
 MINVALUE -9223372036854775808
 MAXVALUE 9223372036854775807
 CACHE 
GO
/****** Object:  UserDefinedFunction [dbo].[_getInstockEndCarrier]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   function [dbo].[_getInstockEndCarrier]
	(
		@begin int,
		@end int
	)	returns int--返回plc 编号+传输线编号 -1 代表不能确定
AS
BEGIN

	DECLARE @res INT;
if @begin=102  begin
	set @res=@end/1000000;
	set @res=@res*2+117;
	 return @res;
end 

	return 0;  
END








GO
/****** Object:  UserDefinedFunction [dbo].[_getLocOffset]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[_getLocOffset]
	(
		@index int,
		@Thickness int
	)	returns int--返回plc 编号+传输线编号 -1 代表不能确定
AS
BEGIN

	    DECLARE @res INT;
		DECLARE @spacing INT;
              if @Thickness=2 begin
				  set @spacing=2580;
			   end else if @Thickness=1 begin
				  set @spacing=2070;
			   end  else begin
			     set @spacing=20000000;--大数垛机无法运行的位置
			   end
	set @res=@index*@spacing-@spacing
	return @res;   
END








GO
/****** Object:  UserDefinedFunction [dbo].[_getOutStockBeginCarrier]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   function [dbo].[_getOutStockBeginCarrier]
	(
		@begin int,
		@end int
	)	returns int --返回plc 编号+传输线编号 -1 代表不能确定
AS
BEGIN
	   if @begin>6000000 begin
			return 225;
		end else if @begin>5000000 begin
			return 227;
		end else if @begin>4000000 begin
			return 229;
		end else if @begin>3000000 begin
			return 231;
		end else if @begin>2000000 begin
			return 233;
		end else if @begin>1000000 begin
			return 235;
		end else if @begin>70000 and  @begin<90000 begin--成品入口
	   
					return @end-1;

		end  
		 
		return 0
END








GO
/****** Object:  Table [dbo].[BBTaskNo]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BBTaskNo](
	[dateline] [date] NOT NULL,
	[value] [bigint] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NoTaskControl]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NoTaskControl](
	[id] [bigint] NULL,
	[controlkey] [varchar](50) NULL,
	[value] [int] NULL,
	[remark] [varchar](200) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[physical_Location]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[physical_Location](
	[id] [bigint] NOT NULL,
	[ShelfId] [int] NOT NULL,
	[craneId] [smallint] NOT NULL DEFAULT ((0)),
	[Row] [int] NOT NULL,
	[Col] [int] NOT NULL,
	[X] [int] NOT NULL,
	[Y] [int] NOT NULL,
	[Z] [int] NOT NULL DEFAULT ((0)),
	[deep] [smallint] NOT NULL DEFAULT ((0)),
	[Direction] [smallint] NOT NULL DEFAULT ((0)),
	[signPoint] [int] NOT NULL DEFAULT ((0)),
 CONSTRAINT [PK_physical_Location] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RTConfig]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RTConfig](
	[ID] [int] NOT NULL,
	[overstop] [smallint] NULL,
	[Cranestatus] [smallint] NULL,
	[centerDistance1] [int] NULL,
	[centerDistance2] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Task_Carrier]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Task_Carrier](
	[ID] [bigint] NOT NULL,
	[TaskNo] [int] NOT NULL,
	[code] [varchar](50) NULL,
	[StartPath] [smallint] NOT NULL,
	[EndPath] [smallint] NOT NULL,
	[status] [smallint] NOT NULL,
	[completeId] [bigint] NOT NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[Extra] [varchar](50) NULL,
	[itemType] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Task_complete]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Task_complete](
	[Id] [bigint] NOT NULL,
	[type] [smallint] NOT NULL,
	[createTime] [datetime2](7) NULL,
	[endTime] [datetime] NULL,
	[info] [varchar](100) NULL,
	[src] [bigint] NULL,
	[des] [bigint] NULL,
	[status] [smallint] NULL,
	[wmsTaskId] [bigint] NULL,
	[Priority] [smallint] NULL,
	[relyTaskId] [bigint] NULL,
	[boxCode] [varchar](50) NULL,
	[itemType] [int] NULL,
	[upload] [smallint] NULL,
 CONSTRAINT [PK__Task_com__3214EC0764EA5C24] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Task_Crane]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Task_Crane](
	[ID] [bigint] NOT NULL,
	[craneId] [smallint] NULL,
	[completeId] [bigint] NULL,
	[TaskNo] [int] NULL,
	[code] [varchar](50) NOT NULL,
	[locX] [int] NULL,
	[locY] [int] NULL,
	[locZ] [int] NULL,
	[locDir] [tinyint] NULL,
	[locId] [int] NULL,
	[Status] [int] NULL,
	[Priority] [int] NULL,
	[MotionType] [tinyint] NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[Extra] [varchar](50) NULL,
	[type] [tinyint] NULL,
	[ForkNo] [int] NULL,
	[itemType] [int] NULL,
 CONSTRAINT [PK__Crane_Ta__3214EC2724927208] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Task_Crane_rely]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Task_Crane_rely](
	[taskId] [bigint] NULL,
	[relyId] [bigint] NULL,
	[completeId] [bigint] NULL,
	[tight] [varchar](2) NULL,
	[DeviceId] [smallint] NULL,
	[id] [bigint] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Task_human]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Task_human](
	[id] [bigint] NOT NULL,
	[completeId] [bigint] NULL,
	[TaskNo] [int] NULL,
	[Status] [int] NULL,
	[createDate] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[Extra] [varchar](100) NULL,
	[Code] [varchar](50) NULL,
	[stn] [smallint] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Task_MechineHand]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Task_MechineHand](
	[ID] [bigint] NOT NULL,
	[TaskNo] [int] NOT NULL,
	[code] [varchar](50) NULL,
	[StartPath] [smallint] NOT NULL,
	[EndPath] [smallint] NOT NULL,
	[status] [smallint] NOT NULL,
	[completeId] [bigint] NOT NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[Extra] [varchar](50) NULL,
	[itemType] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[BBTaskNo] ([dateline], [value]) VALUES (CAST(N'2019-12-23' AS Date), 122300020)
INSERT [dbo].[BBTaskNo] ([dateline], [value]) VALUES (CAST(N'2019-12-25' AS Date), 122501123)
INSERT [dbo].[BBTaskNo] ([dateline], [value]) VALUES (CAST(N'2019-12-27' AS Date), 122701830)
INSERT [dbo].[BBTaskNo] ([dateline], [value]) VALUES (CAST(N'2019-12-29' AS Date), 122900284)
INSERT [dbo].[BBTaskNo] ([dateline], [value]) VALUES (CAST(N'2020-01-01' AS Date), 10100018)
INSERT [dbo].[BBTaskNo] ([dateline], [value]) VALUES (CAST(N'2020-01-06' AS Date), 10603184)
INSERT [dbo].[BBTaskNo] ([dateline], [value]) VALUES (CAST(N'2020-01-07' AS Date), 10703096)
INSERT [dbo].[BBTaskNo] ([dateline], [value]) VALUES (CAST(N'2020-01-08' AS Date), 10801334)
INSERT [dbo].[BBTaskNo] ([dateline], [value]) VALUES (CAST(N'2020-01-13' AS Date), 11301270)
INSERT [dbo].[BBTaskNo] ([dateline], [value]) VALUES (CAST(N'2020-01-14' AS Date), 11400658)
INSERT [dbo].[BBTaskNo] ([dateline], [value]) VALUES (CAST(N'2020-01-15' AS Date), 11500646)
INSERT [dbo].[BBTaskNo] ([dateline], [value]) VALUES (CAST(N'2020-01-16' AS Date), 11600082)
INSERT [dbo].[BBTaskNo] ([dateline], [value]) VALUES (CAST(N'2019-12-24' AS Date), 122400011)
INSERT [dbo].[BBTaskNo] ([dateline], [value]) VALUES (CAST(N'2019-12-26' AS Date), 122600926)
INSERT [dbo].[BBTaskNo] ([dateline], [value]) VALUES (CAST(N'2019-12-28' AS Date), 122800742)
INSERT [dbo].[BBTaskNo] ([dateline], [value]) VALUES (CAST(N'2019-12-30' AS Date), 123000124)
INSERT [dbo].[BBTaskNo] ([dateline], [value]) VALUES (CAST(N'2019-12-31' AS Date), 123100041)
INSERT [dbo].[BBTaskNo] ([dateline], [value]) VALUES (CAST(N'2020-01-02' AS Date), 10200006)
INSERT [dbo].[BBTaskNo] ([dateline], [value]) VALUES (CAST(N'2020-01-03' AS Date), 10300010)
INSERT [dbo].[BBTaskNo] ([dateline], [value]) VALUES (CAST(N'2020-01-04' AS Date), 10400014)
INSERT [dbo].[BBTaskNo] ([dateline], [value]) VALUES (CAST(N'2020-01-05' AS Date), 10500008)
INSERT [dbo].[BBTaskNo] ([dateline], [value]) VALUES (CAST(N'2020-01-09' AS Date), 10901868)
INSERT [dbo].[BBTaskNo] ([dateline], [value]) VALUES (CAST(N'2020-01-10' AS Date), 11001238)
INSERT [dbo].[BBTaskNo] ([dateline], [value]) VALUES (CAST(N'2020-01-11' AS Date), 11102450)
INSERT [dbo].[NoTaskControl] ([id], [controlkey], [value], [remark]) VALUES (99, N'Manipulator', 1, N'盘子型号')
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (1191, 1, 1, 0, 0, 15550, 5470, 1, 1, 2, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (1192, 1, 1, 0, 0, 9400, 5470, 1, 1, 2, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (1211, 2, 1, 0, 0, 15550, 5470, 1, 1, 1, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (1212, 2, 1, 0, 0, 9400, 5470, 1, 1, 1, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (1231, 3, 2, 0, 0, 15620, 5570, 1, 1, 2, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (1232, 3, 2, 0, 0, 9470, 5570, 1, 1, 2, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (1251, 4, 2, 0, 0, 15620, 5570, 1, 1, 1, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (1252, 4, 2, 0, 0, 9470, 5570, 1, 1, 1, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (1271, 5, 3, 0, 0, 0, 0, 1, 1, 1, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (1272, 5, 3, 0, 0, 0, 0, 1, 1, 1, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (1291, 6, 3, 0, 0, 0, 0, 1, 1, 1, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (1292, 6, 3, 0, 0, 0, 0, 1, 1, 1, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (2141, 1, 1, 0, 0, 448010, 4304, 0, 1, 2, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (2142, 1, 1, 0, 0, 454160, 4304, 0, 1, 2, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (2161, 2, 1, 0, 0, 448010, 4304, 0, 1, 1, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (2162, 2, 1, 0, 0, 454160, 4304, 0, 1, 1, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (2181, 3, 2, 0, 0, 448040, 4472, 0, 1, 2, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (2182, 3, 2, 0, 0, 454190, 4472, 0, 1, 2, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (2201, 4, 2, 0, 0, 448040, 4472, 0, 1, 1, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (2202, 4, 2, 0, 0, 454190, 4472, 0, 1, 1, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (2221, 5, 3, 0, 0, 0, 0, 0, 1, 2, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (2222, 5, 3, 0, 0, 0, 0, 0, 1, 2, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (2241, 6, 3, 0, 0, 0, 0, 0, 1, 1, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (2242, 6, 3, 0, 0, 0, 0, 0, 1, 1, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (2251, 6, 3, 0, 0, 0, 0, 0, 1, 1, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (2252, 6, 3, 0, 0, 0, 0, 0, 1, 1, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (2271, 5, 3, 0, 0, 0, 0, 0, 1, 2, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (2272, 5, 3, 0, 0, 0, 0, 0, 1, 2, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (2291, 4, 2, 0, 0, 448040, 12500, 0, 1, 1, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (2292, 4, 2, 0, 0, 454190, 12500, 0, 1, 1, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (2311, 3, 2, 0, 0, 448040, 12500, 0, 1, 2, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (2312, 3, 2, 0, 0, 454190, 12500, 0, 1, 2, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (2331, 2, 1, 0, 0, 448010, 12409, 0, 1, 1, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (2332, 2, 1, 0, 0, 454160, 12409, 0, 1, 1, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (2351, 1, 1, 0, 0, 448010, 12409, 0, 1, 2, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (2352, 1, 1, 0, 0, 454160, 12409, 0, 1, 2, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (3041, 0, 4, 0, 0, 6380, 6518, 1, 1, 2, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (3051, 0, 4, 0, 0, 0, -60, 1, 1, 2, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (3071, 0, 4, 0, 0, 277237, 6713, 1, 1, 1, 1)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10101, 1, 1, 1, 1, 441855, 3535, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10102, 1, 1, 2, 1, 441855, 7540, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10103, 1, 1, 3, 1, 441855, 11546, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10104, 1, 1, 4, 1, 441855, 15513, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10105, 1, 1, 5, 1, 441855, 19522, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10106, 1, 1, 6, 1, 441855, 23524, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10107, 1, 1, 7, 1, 441855, 29000, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10108, 1, 1, 8, 1, 441855, 32984, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10109, 1, 1, 9, 1, 441855, 36980, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10110, 1, 1, 10, 1, 441855, 40963, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10111, 1, 1, 11, 1, 441855, 44956, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10112, 1, 1, 12, 1, 441855, 48944, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10113, 1, 1, 13, 1, 441855, 54431, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10114, 1, 1, 14, 1, 441855, 58426, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10115, 1, 1, 15, 1, 441855, 62428, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10116, 1, 1, 16, 1, 441855, 66396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10117, 1, 1, 17, 1, 441855, 70396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10118, 1, 1, 18, 1, 441855, 74401, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10201, 1, 1, 1, 2, 416929, 3535, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10202, 1, 1, 2, 2, 416929, 7540, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10203, 1, 1, 3, 2, 416929, 11546, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10204, 1, 1, 4, 2, 416929, 15513, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10205, 1, 1, 5, 2, 416929, 19522, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10206, 1, 1, 6, 2, 416929, 23524, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10207, 1, 1, 7, 2, 416929, 29000, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10208, 1, 1, 8, 2, 416929, 32984, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10209, 1, 1, 9, 2, 416929, 36980, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10210, 1, 1, 10, 2, 416929, 40963, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10211, 1, 1, 11, 2, 416929, 44956, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10212, 1, 1, 12, 2, 416929, 48944, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10213, 1, 1, 13, 2, 416929, 54431, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10214, 1, 1, 14, 2, 416929, 58426, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10215, 1, 1, 15, 2, 416929, 62428, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10216, 1, 1, 16, 2, 416929, 66396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10217, 1, 1, 17, 2, 416929, 70396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10218, 1, 1, 18, 2, 416929, 74401, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10301, 1, 1, 1, 3, 391968, 3535, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10302, 1, 1, 2, 3, 391968, 7540, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10303, 1, 1, 3, 3, 391968, 11546, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10304, 1, 1, 4, 3, 391968, 15513, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10305, 1, 1, 5, 3, 391968, 19522, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10306, 1, 1, 6, 3, 391968, 23524, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10307, 1, 1, 7, 3, 391968, 29000, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10308, 1, 1, 8, 3, 391968, 32984, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10309, 1, 1, 9, 3, 391968, 36980, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10310, 1, 1, 10, 3, 391968, 40963, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10311, 1, 1, 11, 3, 391968, 44956, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10312, 1, 1, 12, 3, 391968, 48944, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10313, 1, 1, 13, 3, 391968, 54431, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10314, 1, 1, 14, 3, 391968, 58426, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10315, 1, 1, 15, 3, 391968, 62428, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10316, 1, 1, 16, 3, 391968, 66396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10317, 1, 1, 17, 3, 391968, 70396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10318, 1, 1, 18, 3, 391968, 74401, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10401, 1, 1, 1, 4, 367015, 3535, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10402, 1, 1, 2, 4, 367015, 7540, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10403, 1, 1, 3, 4, 367015, 11546, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10404, 1, 1, 4, 4, 367015, 15513, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10405, 1, 1, 5, 4, 367015, 19522, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10406, 1, 1, 6, 4, 367015, 23524, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10407, 1, 1, 7, 4, 367015, 29000, 0, 1, 2, 0)
GO
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10408, 1, 1, 8, 4, 367015, 32984, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10409, 1, 1, 9, 4, 367015, 36980, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10410, 1, 1, 10, 4, 367015, 40963, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10411, 1, 1, 11, 4, 367015, 44956, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10412, 1, 1, 12, 4, 367015, 48944, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10413, 1, 1, 13, 4, 367015, 54431, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10414, 1, 1, 14, 4, 367015, 58426, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10415, 1, 1, 15, 4, 367015, 62428, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10416, 1, 1, 16, 4, 367015, 66396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10417, 1, 1, 17, 4, 367015, 70396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10418, 1, 1, 18, 4, 367015, 74401, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10501, 1, 1, 1, 5, 342088, 3535, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10502, 1, 1, 2, 5, 342088, 7540, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10503, 1, 1, 3, 5, 342088, 11546, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10504, 1, 1, 4, 5, 342088, 15513, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10505, 1, 1, 5, 5, 342088, 19522, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10506, 1, 1, 6, 5, 342088, 23524, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10507, 1, 1, 7, 5, 342088, 29000, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10508, 1, 1, 8, 5, 342088, 32984, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10509, 1, 1, 9, 5, 342088, 36980, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10510, 1, 1, 10, 5, 342088, 40963, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10511, 1, 1, 11, 5, 342088, 44956, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10512, 1, 1, 12, 5, 342088, 48944, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10513, 1, 1, 13, 5, 342088, 54431, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10514, 1, 1, 14, 5, 342088, 58426, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10515, 1, 1, 15, 5, 342088, 62428, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10516, 1, 1, 16, 5, 342088, 66396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10517, 1, 1, 17, 5, 342088, 70396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10518, 1, 1, 18, 5, 342088, 74401, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10601, 1, 1, 1, 6, 317124, 3535, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10602, 1, 1, 2, 6, 317124, 7540, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10603, 1, 1, 3, 6, 317124, 11546, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10604, 1, 1, 4, 6, 317124, 15513, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10605, 1, 1, 5, 6, 317124, 19522, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10606, 1, 1, 6, 6, 317124, 23524, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10607, 1, 1, 7, 6, 317124, 29000, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10608, 1, 1, 8, 6, 317124, 32984, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10609, 1, 1, 9, 6, 317124, 36980, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10610, 1, 1, 10, 6, 317124, 40963, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10611, 1, 1, 11, 6, 317124, 44956, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10612, 1, 1, 12, 6, 317124, 48944, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10613, 1, 1, 13, 6, 317124, 54431, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10614, 1, 1, 14, 6, 317124, 58426, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10615, 1, 1, 15, 6, 317124, 62428, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10616, 1, 1, 16, 6, 317124, 66396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10617, 1, 1, 17, 6, 317124, 70396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10618, 1, 1, 18, 6, 317124, 74401, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10701, 1, 1, 1, 7, 292187, 3535, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10702, 1, 1, 2, 7, 292187, 7540, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10703, 1, 1, 3, 7, 292187, 11546, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10704, 1, 1, 4, 7, 292187, 15513, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10705, 1, 1, 5, 7, 292187, 19522, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10706, 1, 1, 6, 7, 292187, 23524, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10707, 1, 1, 7, 7, 292187, 29000, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10708, 1, 1, 8, 7, 292187, 32984, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10709, 1, 1, 9, 7, 292187, 36980, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10710, 1, 1, 10, 7, 292187, 40963, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10711, 1, 1, 11, 7, 292187, 44956, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10712, 1, 1, 12, 7, 292187, 48944, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10713, 1, 1, 13, 7, 292187, 54431, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10714, 1, 1, 14, 7, 292187, 58426, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10715, 1, 1, 15, 7, 292187, 62428, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10716, 1, 1, 16, 7, 292187, 66396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10717, 1, 1, 17, 7, 292187, 70396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10718, 1, 1, 18, 7, 292187, 74401, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10801, 1, 1, 1, 8, 267222, 3535, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10802, 1, 1, 2, 8, 267222, 7540, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10803, 1, 1, 3, 8, 267222, 11546, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10804, 1, 1, 4, 8, 267222, 15513, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10805, 1, 1, 5, 8, 267222, 19522, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10806, 1, 1, 6, 8, 267222, 23524, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10807, 1, 1, 7, 8, 267222, 29000, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10808, 1, 1, 8, 8, 267222, 32984, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10809, 1, 1, 9, 8, 267222, 36980, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10810, 1, 1, 10, 8, 267222, 40963, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10811, 1, 1, 11, 8, 267222, 44956, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10812, 1, 1, 12, 8, 267222, 48944, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10813, 1, 1, 13, 8, 267222, 54431, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10814, 1, 1, 14, 8, 267222, 58426, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10815, 1, 1, 15, 8, 267222, 62428, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10816, 1, 1, 16, 8, 267222, 66396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10817, 1, 1, 17, 8, 267222, 70396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10818, 1, 1, 18, 8, 267222, 74401, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10901, 1, 1, 1, 9, 242268, 3535, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10902, 1, 1, 2, 9, 242268, 7540, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10903, 1, 1, 3, 9, 242268, 11546, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10904, 1, 1, 4, 9, 242268, 15513, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10905, 1, 1, 5, 9, 242268, 19522, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10906, 1, 1, 6, 9, 242268, 23524, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10907, 1, 1, 7, 9, 242268, 29000, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10908, 1, 1, 8, 9, 242268, 32984, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10909, 1, 1, 9, 9, 242268, 36980, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10910, 1, 1, 10, 9, 242268, 40963, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10911, 1, 1, 11, 9, 242268, 44956, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10912, 1, 1, 12, 9, 242268, 48944, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10913, 1, 1, 13, 9, 242268, 54431, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10914, 1, 1, 14, 9, 242268, 58426, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10915, 1, 1, 15, 9, 242268, 62428, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10916, 1, 1, 16, 9, 242268, 66396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10917, 1, 1, 17, 9, 242268, 70396, 0, 1, 2, 0)
GO
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (10918, 1, 1, 18, 9, 242268, 74401, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11001, 1, 1, 1, 10, 217302, 3535, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11002, 1, 1, 2, 10, 217302, 7540, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11003, 1, 1, 3, 10, 217302, 11546, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11004, 1, 1, 4, 10, 217302, 15513, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11005, 1, 1, 5, 10, 217302, 19522, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11006, 1, 1, 6, 10, 217302, 23524, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11007, 1, 1, 7, 10, 217302, 29000, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11008, 1, 1, 8, 10, 217302, 32984, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11009, 1, 1, 9, 10, 217302, 36980, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11010, 1, 1, 10, 10, 217302, 40963, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11011, 1, 1, 11, 10, 217302, 44956, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11012, 1, 1, 12, 10, 217302, 48944, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11013, 1, 1, 13, 10, 217302, 54431, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11014, 1, 1, 14, 10, 217302, 58426, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11015, 1, 1, 15, 10, 217302, 62428, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11016, 1, 1, 16, 10, 217302, 66396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11017, 1, 1, 17, 10, 217302, 70396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11018, 1, 1, 18, 10, 217302, 74401, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11101, 1, 1, 1, 11, 192368, 3535, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11102, 1, 1, 2, 11, 192368, 7540, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11103, 1, 1, 3, 11, 192368, 11546, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11104, 1, 1, 4, 11, 192368, 15513, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11105, 1, 1, 5, 11, 192368, 19522, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11106, 1, 1, 6, 11, 192368, 23524, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11107, 1, 1, 7, 11, 192368, 29000, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11108, 1, 1, 8, 11, 192368, 32984, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11109, 1, 1, 9, 11, 192368, 36980, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11110, 1, 1, 10, 11, 192368, 40963, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11111, 1, 1, 11, 11, 192368, 44956, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11112, 1, 1, 12, 11, 192368, 48944, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11113, 1, 1, 13, 11, 192368, 54431, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11114, 1, 1, 14, 11, 192368, 58426, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11115, 1, 1, 15, 11, 192368, 62428, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11116, 1, 1, 16, 11, 192368, 66396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11117, 1, 1, 17, 11, 192368, 70396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11118, 1, 1, 18, 11, 192368, 74401, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11201, 1, 1, 1, 12, 167441, 3535, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11202, 1, 1, 2, 12, 167441, 7540, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11203, 1, 1, 3, 12, 167441, 11546, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11204, 1, 1, 4, 12, 167441, 15513, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11205, 1, 1, 5, 12, 167441, 19522, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11206, 1, 1, 6, 12, 167441, 23524, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11207, 1, 1, 7, 12, 167441, 29000, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11208, 1, 1, 8, 12, 167441, 32984, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11209, 1, 1, 9, 12, 167441, 36980, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11210, 1, 1, 10, 12, 167441, 40963, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11211, 1, 1, 11, 12, 167441, 44956, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11212, 1, 1, 12, 12, 167441, 48944, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11213, 1, 1, 13, 12, 167441, 54431, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11214, 1, 1, 14, 12, 167441, 58426, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11215, 1, 1, 15, 12, 167441, 62428, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11216, 1, 1, 16, 12, 167441, 66396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11217, 1, 1, 17, 12, 167441, 70396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11218, 1, 1, 18, 12, 167441, 74401, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11301, 1, 1, 1, 13, 142468, 3535, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11302, 1, 1, 2, 13, 142468, 7540, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11303, 1, 1, 3, 13, 142468, 11546, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11304, 1, 1, 4, 13, 142468, 15513, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11305, 1, 1, 5, 13, 142468, 19522, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11306, 1, 1, 6, 13, 142468, 23524, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11307, 1, 1, 7, 13, 142468, 29000, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11308, 1, 1, 8, 13, 142468, 32984, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11309, 1, 1, 9, 13, 142468, 36980, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11310, 1, 1, 10, 13, 142468, 40963, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11311, 1, 1, 11, 13, 142468, 44956, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11312, 1, 1, 12, 13, 142468, 48944, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11313, 1, 1, 13, 13, 142468, 54431, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11314, 1, 1, 14, 13, 142468, 58426, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11315, 1, 1, 15, 13, 142468, 62428, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11316, 1, 1, 16, 13, 142468, 66396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11317, 1, 1, 17, 13, 142468, 70396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11318, 1, 1, 18, 13, 142468, 74401, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11401, 1, 1, 1, 14, 117500, 3535, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11402, 1, 1, 2, 14, 117500, 7540, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11403, 1, 1, 3, 14, 117500, 11546, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11404, 1, 1, 4, 14, 117500, 15513, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11405, 1, 1, 5, 14, 117500, 19522, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11406, 1, 1, 6, 14, 117500, 23524, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11407, 1, 1, 7, 14, 117500, 29000, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11408, 1, 1, 8, 14, 117500, 32984, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11409, 1, 1, 9, 14, 117500, 36980, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11410, 1, 1, 10, 14, 117500, 40963, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11411, 1, 1, 11, 14, 117500, 44956, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11412, 1, 1, 12, 14, 117500, 48944, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11413, 1, 1, 13, 14, 117500, 54431, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11414, 1, 1, 14, 14, 117500, 58426, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11415, 1, 1, 15, 14, 117500, 62428, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11416, 1, 1, 16, 14, 117500, 66396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11417, 1, 1, 17, 14, 117500, 70396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11418, 1, 1, 18, 14, 117500, 74401, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11501, 1, 1, 1, 15, 92575, 3535, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11502, 1, 1, 2, 15, 92575, 7540, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11503, 1, 1, 3, 15, 92575, 11546, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11504, 1, 1, 4, 15, 92575, 15513, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11505, 1, 1, 5, 15, 92575, 19522, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11506, 1, 1, 6, 15, 92575, 23524, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11507, 1, 1, 7, 15, 92575, 29000, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11508, 1, 1, 8, 15, 92575, 32984, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11509, 1, 1, 9, 15, 92575, 36980, 0, 1, 2, 0)
GO
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11510, 1, 1, 10, 15, 92575, 40963, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11511, 1, 1, 11, 15, 92575, 44956, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11512, 1, 1, 12, 15, 92575, 48944, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11513, 1, 1, 13, 15, 92575, 54431, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11514, 1, 1, 14, 15, 92575, 58426, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11515, 1, 1, 15, 15, 92575, 62428, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11516, 1, 1, 16, 15, 92575, 66396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11517, 1, 1, 17, 15, 92575, 70396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11518, 1, 1, 18, 15, 92575, 74401, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11601, 1, 1, 1, 16, 67621, 3535, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11602, 1, 1, 2, 16, 67621, 7540, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11603, 1, 1, 3, 16, 67621, 11546, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11604, 1, 1, 4, 16, 67621, 15513, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11605, 1, 1, 5, 16, 67621, 19522, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11606, 1, 1, 6, 16, 67621, 23524, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11607, 1, 1, 7, 16, 67621, 29000, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11608, 1, 1, 8, 16, 67621, 32984, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11609, 1, 1, 9, 16, 67621, 36980, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11610, 1, 1, 10, 16, 67621, 40963, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11611, 1, 1, 11, 16, 67621, 44956, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11612, 1, 1, 12, 16, 67621, 48944, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11613, 1, 1, 13, 16, 67621, 54431, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11614, 1, 1, 14, 16, 67621, 58426, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11615, 1, 1, 15, 16, 67621, 62428, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11616, 1, 1, 16, 16, 67621, 66396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11617, 1, 1, 17, 16, 67621, 70396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11618, 1, 1, 18, 16, 67621, 74401, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11701, 1, 1, 1, 17, 42674, 3535, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11702, 1, 1, 2, 17, 42674, 7540, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11703, 1, 1, 3, 17, 42674, 11546, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11704, 1, 1, 4, 17, 42674, 15513, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11705, 1, 1, 5, 17, 42674, 19522, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11706, 1, 1, 6, 17, 42674, 23524, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11707, 1, 1, 7, 17, 42674, 29000, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11708, 1, 1, 8, 17, 42674, 32984, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11709, 1, 1, 9, 17, 42674, 36980, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11710, 1, 1, 10, 17, 42674, 40963, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11711, 1, 1, 11, 17, 42674, 44956, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11712, 1, 1, 12, 17, 42674, 48944, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11713, 1, 1, 13, 17, 42674, 54431, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11714, 1, 1, 14, 17, 42674, 58426, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11715, 1, 1, 15, 17, 42674, 62428, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11716, 1, 1, 16, 17, 42674, 66396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11717, 1, 1, 17, 17, 42674, 70396, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (11718, 1, 1, 18, 17, 42674, 74401, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20101, 2, 1, 1, 1, 441855, 3540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20102, 2, 1, 2, 1, 441855, 7540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20103, 2, 1, 3, 1, 441855, 11548, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20104, 2, 1, 4, 1, 441855, 15537, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20105, 2, 1, 5, 1, 441855, 19532, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20106, 2, 1, 6, 1, 441855, 23527, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20107, 2, 1, 7, 1, 441855, 29021, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20108, 2, 1, 8, 1, 441855, 33013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20109, 2, 1, 9, 1, 441855, 37019, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20110, 2, 1, 10, 1, 441855, 41013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20111, 2, 1, 11, 1, 441855, 45003, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20112, 2, 1, 12, 1, 441855, 49007, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20113, 2, 1, 13, 1, 441855, 54469, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20114, 2, 1, 14, 1, 441855, 58470, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20115, 2, 1, 15, 1, 441855, 62458, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20116, 2, 1, 16, 1, 441855, 66462, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20117, 2, 1, 17, 1, 441855, 70460, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20118, 2, 1, 18, 1, 441855, 74446, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20201, 2, 1, 1, 2, 416901, 3540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20202, 2, 1, 2, 2, 416901, 7540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20203, 2, 1, 3, 2, 416901, 11548, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20204, 2, 1, 4, 2, 416901, 15537, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20205, 2, 1, 5, 2, 416901, 19532, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20206, 2, 1, 6, 2, 416901, 23527, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20207, 2, 1, 7, 2, 416901, 29021, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20208, 2, 1, 8, 2, 416901, 33013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20209, 2, 1, 9, 2, 416901, 37019, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20210, 2, 1, 10, 2, 416901, 41013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20211, 2, 1, 11, 2, 416901, 45003, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20212, 2, 1, 12, 2, 416901, 49007, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20213, 2, 1, 13, 2, 416901, 54469, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20214, 2, 1, 14, 2, 416901, 58470, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20215, 2, 1, 15, 2, 416901, 62458, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20216, 2, 1, 16, 2, 416901, 66462, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20217, 2, 1, 17, 2, 416901, 70460, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20218, 2, 1, 18, 2, 416901, 74446, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20301, 2, 1, 1, 3, 391954, 3540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20302, 2, 1, 2, 3, 391954, 7540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20303, 2, 1, 3, 3, 391954, 11548, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20304, 2, 1, 4, 3, 391954, 15537, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20305, 2, 1, 5, 3, 391954, 19532, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20306, 2, 1, 6, 3, 391954, 23527, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20307, 2, 1, 7, 3, 391954, 29021, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20308, 2, 1, 8, 3, 391954, 33013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20309, 2, 1, 9, 3, 391954, 37019, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20310, 2, 1, 10, 3, 391954, 41013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20311, 2, 1, 11, 3, 391954, 45003, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20312, 2, 1, 12, 3, 391954, 49007, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20313, 2, 1, 13, 3, 391954, 54469, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20314, 2, 1, 14, 3, 391954, 58470, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20315, 2, 1, 15, 3, 391954, 62458, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20316, 2, 1, 16, 3, 391954, 66462, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20317, 2, 1, 17, 3, 391954, 70460, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20318, 2, 1, 18, 3, 391954, 74446, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20401, 2, 1, 1, 4, 367003, 3540, 0, 1, 1, 0)
GO
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20402, 2, 1, 2, 4, 367003, 7540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20403, 2, 1, 3, 4, 367003, 11548, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20404, 2, 1, 4, 4, 367003, 15537, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20405, 2, 1, 5, 4, 367003, 19532, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20406, 2, 1, 6, 4, 367003, 23527, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20407, 2, 1, 7, 4, 367003, 29021, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20408, 2, 1, 8, 4, 367003, 33013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20409, 2, 1, 9, 4, 367003, 37019, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20410, 2, 1, 10, 4, 367003, 41013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20411, 2, 1, 11, 4, 367003, 45003, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20412, 2, 1, 12, 4, 367003, 49007, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20413, 2, 1, 13, 4, 367003, 54469, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20414, 2, 1, 14, 4, 367003, 58470, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20415, 2, 1, 15, 4, 367003, 62458, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20416, 2, 1, 16, 4, 367003, 66462, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20417, 2, 1, 17, 4, 367003, 70460, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20418, 2, 1, 18, 4, 367003, 74446, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20501, 2, 1, 1, 5, 342034, 3540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20502, 2, 1, 2, 5, 342034, 7540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20503, 2, 1, 3, 5, 342034, 11548, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20504, 2, 1, 4, 5, 342034, 15537, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20505, 2, 1, 5, 5, 342034, 19532, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20506, 2, 1, 6, 5, 342034, 23527, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20507, 2, 1, 7, 5, 342034, 29021, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20508, 2, 1, 8, 5, 342034, 33013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20509, 2, 1, 9, 5, 342034, 37019, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20510, 2, 1, 10, 5, 342034, 41013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20511, 2, 1, 11, 5, 342034, 45003, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20512, 2, 1, 12, 5, 342034, 49007, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20513, 2, 1, 13, 5, 342034, 54469, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20514, 2, 1, 14, 5, 342034, 58470, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20515, 2, 1, 15, 5, 342034, 62458, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20516, 2, 1, 16, 5, 342034, 66462, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20517, 2, 1, 17, 5, 342034, 70460, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20518, 2, 1, 18, 5, 342034, 74446, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20601, 2, 1, 1, 6, 317108, 3540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20602, 2, 1, 2, 6, 317108, 7540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20603, 2, 1, 3, 6, 317108, 11548, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20604, 2, 1, 4, 6, 317108, 15537, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20605, 2, 1, 5, 6, 317108, 19532, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20606, 2, 1, 6, 6, 317108, 23527, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20607, 2, 1, 7, 6, 317108, 29021, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20608, 2, 1, 8, 6, 317108, 33013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20609, 2, 1, 9, 6, 317108, 37019, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20610, 2, 1, 10, 6, 317108, 41013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20611, 2, 1, 11, 6, 317108, 45003, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20612, 2, 1, 12, 6, 317108, 49007, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20613, 2, 1, 13, 6, 317108, 54469, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20614, 2, 1, 14, 6, 317108, 58470, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20615, 2, 1, 15, 6, 317108, 62458, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20616, 2, 1, 16, 6, 317108, 66462, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20617, 2, 1, 17, 6, 317108, 70460, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20618, 2, 1, 18, 6, 317108, 74446, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20701, 2, 1, 1, 7, 292155, 3540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20702, 2, 1, 2, 7, 292155, 7540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20703, 2, 1, 3, 7, 292155, 11548, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20704, 2, 1, 4, 7, 292155, 15537, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20705, 2, 1, 5, 7, 292155, 19532, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20706, 2, 1, 6, 7, 292155, 23527, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20707, 2, 1, 7, 7, 292155, 29021, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20708, 2, 1, 8, 7, 292155, 33013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20709, 2, 1, 9, 7, 292155, 37019, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20710, 2, 1, 10, 7, 292155, 41013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20711, 2, 1, 11, 7, 292155, 45003, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20712, 2, 1, 12, 7, 292155, 49007, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20713, 2, 1, 13, 7, 292155, 54469, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20714, 2, 1, 14, 7, 292155, 58470, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20715, 2, 1, 15, 7, 292155, 62458, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20716, 2, 1, 16, 7, 292155, 66462, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20717, 2, 1, 17, 7, 292155, 70460, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20718, 2, 1, 18, 7, 292155, 74446, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20801, 2, 1, 1, 8, 267221, 3540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20802, 2, 1, 2, 8, 267221, 7540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20803, 2, 1, 3, 8, 267221, 11548, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20804, 2, 1, 4, 8, 267221, 15537, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20805, 2, 1, 5, 8, 267221, 19532, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20806, 2, 1, 6, 8, 267221, 23527, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20807, 2, 1, 7, 8, 267221, 29021, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20808, 2, 1, 8, 8, 267221, 33013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20809, 2, 1, 9, 8, 267221, 37019, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20810, 2, 1, 10, 8, 267221, 41013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20811, 2, 1, 11, 8, 267221, 45003, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20812, 2, 1, 12, 8, 267221, 49007, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20813, 2, 1, 13, 8, 267221, 54469, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20814, 2, 1, 14, 8, 267221, 58470, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20815, 2, 1, 15, 8, 267221, 62458, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20816, 2, 1, 16, 8, 267221, 66462, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20817, 2, 1, 17, 8, 267221, 70460, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20818, 2, 1, 18, 8, 267221, 74446, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20901, 2, 1, 1, 9, 242247, 3540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20902, 2, 1, 2, 9, 242247, 7540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20903, 2, 1, 3, 9, 242247, 11548, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20904, 2, 1, 4, 9, 242247, 15537, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20905, 2, 1, 5, 9, 242247, 19532, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20906, 2, 1, 6, 9, 242247, 23527, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20907, 2, 1, 7, 9, 242247, 29021, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20908, 2, 1, 8, 9, 242247, 33013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20909, 2, 1, 9, 9, 242247, 37019, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20910, 2, 1, 10, 9, 242247, 41013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20911, 2, 1, 11, 9, 242247, 45003, 0, 1, 1, 0)
GO
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20912, 2, 1, 12, 9, 242247, 49007, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20913, 2, 1, 13, 9, 242247, 54469, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20914, 2, 1, 14, 9, 242247, 58470, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20915, 2, 1, 15, 9, 242247, 62458, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20916, 2, 1, 16, 9, 242247, 66462, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20917, 2, 1, 17, 9, 242247, 70460, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (20918, 2, 1, 18, 9, 242247, 74446, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21001, 2, 1, 1, 10, 217282, 3540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21002, 2, 1, 2, 10, 217282, 7540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21003, 2, 1, 3, 10, 217282, 11548, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21004, 2, 1, 4, 10, 217282, 15537, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21005, 2, 1, 5, 10, 217282, 19532, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21006, 2, 1, 6, 10, 217282, 23527, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21007, 2, 1, 7, 10, 217282, 29021, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21008, 2, 1, 8, 10, 217282, 33013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21009, 2, 1, 9, 10, 217282, 37019, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21010, 2, 1, 10, 10, 217282, 41013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21011, 2, 1, 11, 10, 217282, 45003, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21012, 2, 1, 12, 10, 217282, 49007, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21013, 2, 1, 13, 10, 217282, 54469, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21014, 2, 1, 14, 10, 217282, 58470, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21015, 2, 1, 15, 10, 217282, 62458, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21016, 2, 1, 16, 10, 217282, 66462, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21017, 2, 1, 17, 10, 217282, 70460, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21018, 2, 1, 18, 10, 217282, 74446, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21101, 2, 1, 1, 11, 192315, 3540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21102, 2, 1, 2, 11, 192315, 7540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21103, 2, 1, 3, 11, 192315, 11548, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21104, 2, 1, 4, 11, 192315, 15537, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21105, 2, 1, 5, 11, 192315, 19532, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21106, 2, 1, 6, 11, 192315, 23527, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21107, 2, 1, 7, 11, 192315, 29021, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21108, 2, 1, 8, 11, 192315, 33013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21109, 2, 1, 9, 11, 192315, 37019, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21110, 2, 1, 10, 11, 192315, 41013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21111, 2, 1, 11, 11, 192315, 45003, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21112, 2, 1, 12, 11, 192315, 49007, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21113, 2, 1, 13, 11, 192315, 54469, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21114, 2, 1, 14, 11, 192315, 58470, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21115, 2, 1, 15, 11, 192315, 62458, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21116, 2, 1, 16, 11, 192315, 66462, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21117, 2, 1, 17, 11, 192315, 70460, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21118, 2, 1, 18, 11, 192315, 74446, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21201, 2, 1, 1, 12, 167379, 3540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21202, 2, 1, 2, 12, 167379, 7540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21203, 2, 1, 3, 12, 167379, 11548, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21204, 2, 1, 4, 12, 167379, 15537, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21205, 2, 1, 5, 12, 167379, 19532, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21206, 2, 1, 6, 12, 167379, 23527, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21207, 2, 1, 7, 12, 167379, 29021, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21208, 2, 1, 8, 12, 167379, 33013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21209, 2, 1, 9, 12, 167379, 37019, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21210, 2, 1, 10, 12, 167379, 41013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21211, 2, 1, 11, 12, 167379, 45003, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21212, 2, 1, 12, 12, 167379, 49007, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21213, 2, 1, 13, 12, 167379, 54469, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21214, 2, 1, 14, 12, 167379, 58470, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21215, 2, 1, 15, 12, 167379, 62458, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21216, 2, 1, 16, 12, 167379, 66462, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21217, 2, 1, 17, 12, 167379, 70460, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21218, 2, 1, 18, 12, 167379, 74446, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21301, 2, 1, 1, 13, 142422, 3540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21302, 2, 1, 2, 13, 142422, 7540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21303, 2, 1, 3, 13, 142422, 11548, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21304, 2, 1, 4, 13, 142422, 15537, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21305, 2, 1, 5, 13, 142422, 19532, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21306, 2, 1, 6, 13, 142422, 23527, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21307, 2, 1, 7, 13, 142422, 29021, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21308, 2, 1, 8, 13, 142422, 33013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21309, 2, 1, 9, 13, 142422, 37019, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21310, 2, 1, 10, 13, 142422, 41013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21311, 2, 1, 11, 13, 142422, 45003, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21312, 2, 1, 12, 13, 142422, 49007, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21313, 2, 1, 13, 13, 142422, 54469, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21314, 2, 1, 14, 13, 142422, 58470, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21315, 2, 1, 15, 13, 142422, 62458, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21316, 2, 1, 16, 13, 142422, 66462, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21317, 2, 1, 17, 13, 142422, 70460, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21318, 2, 1, 18, 13, 142422, 74446, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21401, 2, 1, 1, 14, 117474, 3540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21402, 2, 1, 2, 14, 117474, 7540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21403, 2, 1, 3, 14, 117474, 11548, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21404, 2, 1, 4, 14, 117474, 15537, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21405, 2, 1, 5, 14, 117474, 19532, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21406, 2, 1, 6, 14, 117474, 23527, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21407, 2, 1, 7, 14, 117474, 29021, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21408, 2, 1, 8, 14, 117474, 33013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21409, 2, 1, 9, 14, 117474, 37019, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21410, 2, 1, 10, 14, 117474, 41013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21411, 2, 1, 11, 14, 117474, 45003, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21412, 2, 1, 12, 14, 117474, 49007, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21413, 2, 1, 13, 14, 117474, 54469, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21414, 2, 1, 14, 14, 117474, 58470, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21415, 2, 1, 15, 14, 117474, 62458, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21416, 2, 1, 16, 14, 117474, 66462, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21417, 2, 1, 17, 14, 117474, 70460, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21418, 2, 1, 18, 14, 117474, 74446, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21501, 2, 1, 1, 15, 92521, 3540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21502, 2, 1, 2, 15, 92521, 7540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21503, 2, 1, 3, 15, 92521, 11548, 0, 1, 1, 0)
GO
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21504, 2, 1, 4, 15, 92521, 15537, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21505, 2, 1, 5, 15, 92521, 19532, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21506, 2, 1, 6, 15, 92521, 23527, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21507, 2, 1, 7, 15, 92521, 29021, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21508, 2, 1, 8, 15, 92521, 33013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21509, 2, 1, 9, 15, 92521, 37019, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21510, 2, 1, 10, 15, 92521, 41013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21511, 2, 1, 11, 15, 92521, 45003, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21512, 2, 1, 12, 15, 92521, 49007, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21513, 2, 1, 13, 15, 92521, 54469, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21514, 2, 1, 14, 15, 92521, 58470, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21515, 2, 1, 15, 15, 92521, 62458, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21516, 2, 1, 16, 15, 92521, 66462, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21517, 2, 1, 17, 15, 92521, 70460, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21518, 2, 1, 18, 15, 92521, 74446, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21601, 2, 1, 1, 16, 67579, 3540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21602, 2, 1, 2, 16, 67579, 7540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21603, 2, 1, 3, 16, 67579, 11548, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21604, 2, 1, 4, 16, 67579, 15537, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21605, 2, 1, 5, 16, 67579, 19532, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21606, 2, 1, 6, 16, 67579, 23527, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21607, 2, 1, 7, 16, 67579, 29021, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21608, 2, 1, 8, 16, 67579, 33013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21609, 2, 1, 9, 16, 67579, 37019, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21610, 2, 1, 10, 16, 67579, 41013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21611, 2, 1, 11, 16, 67579, 45003, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21612, 2, 1, 12, 16, 67579, 49007, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21613, 2, 1, 13, 16, 67579, 54469, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21614, 2, 1, 14, 16, 67579, 58470, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21615, 2, 1, 15, 16, 67579, 62458, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21616, 2, 1, 16, 16, 67579, 66462, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21617, 2, 1, 17, 16, 67579, 70460, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21618, 2, 1, 18, 16, 67579, 74446, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21701, 2, 1, 1, 17, 42641, 3540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21702, 2, 1, 2, 17, 42641, 7540, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21703, 2, 1, 3, 17, 42641, 11548, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21704, 2, 1, 4, 17, 42641, 15537, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21705, 2, 1, 5, 17, 42641, 19532, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21706, 2, 1, 6, 17, 42641, 23527, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21707, 2, 1, 7, 17, 42641, 29021, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21708, 2, 1, 8, 17, 42641, 33013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21709, 2, 1, 9, 17, 42641, 37019, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21710, 2, 1, 10, 17, 42641, 41013, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21711, 2, 1, 11, 17, 42641, 45003, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21712, 2, 1, 12, 17, 42641, 49007, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21713, 2, 1, 13, 17, 42641, 54469, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21714, 2, 1, 14, 17, 42641, 58470, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21715, 2, 1, 15, 17, 42641, 62458, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21716, 2, 1, 16, 17, 42641, 66462, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21717, 2, 1, 17, 17, 42641, 70460, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (21718, 2, 1, 18, 17, 42641, 74446, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30101, 3, 2, 1, 1, 441967, 3719, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30102, 3, 2, 2, 1, 441967, 7756, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30103, 3, 2, 3, 1, 441967, 11760, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30104, 3, 2, 4, 1, 441967, 15778, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30105, 3, 2, 5, 1, 441967, 19718, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30106, 3, 2, 6, 1, 441967, 23752, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30107, 3, 2, 7, 1, 441967, 29241, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30108, 3, 2, 8, 1, 441967, 33249, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30109, 3, 2, 9, 1, 441967, 37213, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30110, 3, 2, 10, 1, 441967, 41215, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30111, 3, 2, 11, 1, 441967, 45227, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30112, 3, 2, 12, 1, 441967, 49225, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30113, 3, 2, 13, 1, 441967, 54724, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30114, 3, 2, 14, 1, 441967, 58696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30115, 3, 2, 15, 1, 441967, 62696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30116, 3, 2, 16, 1, 441967, 66690, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30117, 3, 2, 17, 1, 441967, 70686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30118, 3, 2, 18, 1, 441967, 74686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30201, 3, 2, 1, 2, 416990, 3719, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30202, 3, 2, 2, 2, 416990, 7756, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30203, 3, 2, 3, 2, 416990, 11760, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30204, 3, 2, 4, 2, 416990, 15778, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30205, 3, 2, 5, 2, 416990, 19718, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30206, 3, 2, 6, 2, 416990, 23752, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30207, 3, 2, 7, 2, 416990, 29241, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30208, 3, 2, 8, 2, 416990, 33249, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30209, 3, 2, 9, 2, 416990, 37213, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30210, 3, 2, 10, 2, 416990, 41215, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30211, 3, 2, 11, 2, 416990, 45227, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30212, 3, 2, 12, 2, 416990, 49225, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30213, 3, 2, 13, 2, 416990, 54724, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30214, 3, 2, 14, 2, 416990, 58696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30215, 3, 2, 15, 2, 416990, 62696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30216, 3, 2, 16, 2, 416990, 66690, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30217, 3, 2, 17, 2, 416990, 70686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30218, 3, 2, 18, 2, 416990, 74686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30301, 3, 2, 1, 3, 392099, 3719, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30302, 3, 2, 2, 3, 392099, 7756, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30303, 3, 2, 3, 3, 392099, 11760, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30304, 3, 2, 4, 3, 392099, 15778, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30305, 3, 2, 5, 3, 392099, 19718, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30306, 3, 2, 6, 3, 392099, 23752, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30307, 3, 2, 7, 3, 392099, 29241, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30308, 3, 2, 8, 3, 392099, 33249, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30309, 3, 2, 9, 3, 392099, 37213, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30310, 3, 2, 10, 3, 392099, 41215, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30311, 3, 2, 11, 3, 392099, 45227, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30312, 3, 2, 12, 3, 392099, 49225, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30313, 3, 2, 13, 3, 392099, 54724, 0, 1, 2, 0)
GO
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30314, 3, 2, 14, 3, 392099, 58696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30315, 3, 2, 15, 3, 392099, 62696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30316, 3, 2, 16, 3, 392099, 66690, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30317, 3, 2, 17, 3, 392099, 70686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30318, 3, 2, 18, 3, 392099, 74686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30401, 3, 2, 1, 4, 367101, 3719, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30402, 3, 2, 2, 4, 367101, 7756, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30403, 3, 2, 3, 4, 367101, 11760, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30404, 3, 2, 4, 4, 367101, 15778, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30405, 3, 2, 5, 4, 367101, 19718, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30406, 3, 2, 6, 4, 367101, 23752, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30407, 3, 2, 7, 4, 367101, 29241, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30408, 3, 2, 8, 4, 367101, 33249, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30409, 3, 2, 9, 4, 367101, 37213, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30410, 3, 2, 10, 4, 367101, 41215, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30411, 3, 2, 11, 4, 367101, 45227, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30412, 3, 2, 12, 4, 367101, 49225, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30413, 3, 2, 13, 4, 367101, 54724, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30414, 3, 2, 14, 4, 367101, 58696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30415, 3, 2, 15, 4, 367101, 62696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30416, 3, 2, 16, 4, 367101, 66690, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30417, 3, 2, 17, 4, 367101, 70686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30418, 3, 2, 18, 4, 367101, 74686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30501, 3, 2, 1, 5, 342159, 3719, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30502, 3, 2, 2, 5, 342159, 7756, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30503, 3, 2, 3, 5, 342159, 11760, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30504, 3, 2, 4, 5, 342159, 15778, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30505, 3, 2, 5, 5, 342159, 19718, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30506, 3, 2, 6, 5, 342159, 23752, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30507, 3, 2, 7, 5, 342159, 29241, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30508, 3, 2, 8, 5, 342159, 33249, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30509, 3, 2, 9, 5, 342159, 37213, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30510, 3, 2, 10, 5, 342159, 41215, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30511, 3, 2, 11, 5, 342159, 45227, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30512, 3, 2, 12, 5, 342159, 49225, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30513, 3, 2, 13, 5, 342159, 54724, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30514, 3, 2, 14, 5, 342159, 58696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30515, 3, 2, 15, 5, 342159, 62696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30516, 3, 2, 16, 5, 342159, 66690, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30517, 3, 2, 17, 5, 342159, 70686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30518, 3, 2, 18, 5, 342159, 74686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30601, 3, 2, 1, 6, 317211, 3719, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30602, 3, 2, 2, 6, 317211, 7756, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30603, 3, 2, 3, 6, 317211, 11760, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30604, 3, 2, 4, 6, 317211, 15778, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30605, 3, 2, 5, 6, 317211, 19718, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30606, 3, 2, 6, 6, 317211, 23752, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30607, 3, 2, 7, 6, 317211, 29241, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30608, 3, 2, 8, 6, 317211, 33249, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30609, 3, 2, 9, 6, 317211, 37213, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30610, 3, 2, 10, 6, 317211, 41215, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30611, 3, 2, 11, 6, 317211, 45227, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30612, 3, 2, 12, 6, 317211, 49225, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30613, 3, 2, 13, 6, 317211, 54724, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30614, 3, 2, 14, 6, 317211, 58696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30615, 3, 2, 15, 6, 317211, 62696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30616, 3, 2, 16, 6, 317211, 66690, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30617, 3, 2, 17, 6, 317211, 70686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30618, 3, 2, 18, 6, 317211, 74686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30701, 3, 2, 1, 7, 292245, 3719, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30702, 3, 2, 2, 7, 292245, 7756, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30703, 3, 2, 3, 7, 292245, 11760, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30704, 3, 2, 4, 7, 292245, 15778, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30705, 3, 2, 5, 7, 292245, 19718, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30706, 3, 2, 6, 7, 292245, 23752, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30707, 3, 2, 7, 7, 292245, 29241, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30708, 3, 2, 8, 7, 292245, 33249, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30709, 3, 2, 9, 7, 292245, 37213, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30710, 3, 2, 10, 7, 292245, 41215, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30711, 3, 2, 11, 7, 292245, 45227, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30712, 3, 2, 12, 7, 292245, 49225, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30713, 3, 2, 13, 7, 292245, 54724, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30714, 3, 2, 14, 7, 292245, 58696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30715, 3, 2, 15, 7, 292245, 62696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30716, 3, 2, 16, 7, 292245, 66690, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30717, 3, 2, 17, 7, 292245, 70686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30718, 3, 2, 18, 7, 292245, 74686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30801, 3, 2, 1, 8, 267286, 3719, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30802, 3, 2, 2, 8, 267286, 7756, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30803, 3, 2, 3, 8, 267286, 11760, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30804, 3, 2, 4, 8, 267286, 15778, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30805, 3, 2, 5, 8, 267286, 19718, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30806, 3, 2, 6, 8, 267286, 23752, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30807, 3, 2, 7, 8, 267286, 29241, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30808, 3, 2, 8, 8, 267286, 33249, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30809, 3, 2, 9, 8, 267286, 37213, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30810, 3, 2, 10, 8, 267286, 41215, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30811, 3, 2, 11, 8, 267286, 45227, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30812, 3, 2, 12, 8, 267286, 49225, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30813, 3, 2, 13, 8, 267286, 54724, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30814, 3, 2, 14, 8, 267286, 58696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30815, 3, 2, 15, 8, 267286, 62696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30816, 3, 2, 16, 8, 267286, 66690, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30817, 3, 2, 17, 8, 267286, 70686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30818, 3, 2, 18, 8, 267286, 74686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30901, 3, 2, 1, 9, 242325, 3719, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30902, 3, 2, 2, 9, 242325, 7756, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30903, 3, 2, 3, 9, 242325, 11760, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30904, 3, 2, 4, 9, 242325, 15778, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30905, 3, 2, 5, 9, 242325, 19718, 0, 1, 2, 0)
GO
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30906, 3, 2, 6, 9, 242325, 23752, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30907, 3, 2, 7, 9, 242325, 29241, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30908, 3, 2, 8, 9, 242325, 33249, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30909, 3, 2, 9, 9, 242325, 37213, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30910, 3, 2, 10, 9, 242325, 41215, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30911, 3, 2, 11, 9, 242325, 45227, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30912, 3, 2, 12, 9, 242325, 49225, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30913, 3, 2, 13, 9, 242325, 54724, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30914, 3, 2, 14, 9, 242325, 58696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30915, 3, 2, 15, 9, 242325, 62696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30916, 3, 2, 16, 9, 242325, 66690, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30917, 3, 2, 17, 9, 242325, 70686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (30918, 3, 2, 18, 9, 242325, 74686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31001, 3, 2, 1, 10, 217383, 3719, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31002, 3, 2, 2, 10, 217383, 7756, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31003, 3, 2, 3, 10, 217383, 11760, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31004, 3, 2, 4, 10, 217383, 15778, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31005, 3, 2, 5, 10, 217383, 19718, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31006, 3, 2, 6, 10, 217383, 23752, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31007, 3, 2, 7, 10, 217383, 29241, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31008, 3, 2, 8, 10, 217383, 33249, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31009, 3, 2, 9, 10, 217383, 37213, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31010, 3, 2, 10, 10, 217383, 41215, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31011, 3, 2, 11, 10, 217383, 45227, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31012, 3, 2, 12, 10, 217383, 49225, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31013, 3, 2, 13, 10, 217383, 54724, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31014, 3, 2, 14, 10, 217383, 58696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31015, 3, 2, 15, 10, 217383, 62696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31016, 3, 2, 16, 10, 217383, 66690, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31017, 3, 2, 17, 10, 217383, 70686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31018, 3, 2, 18, 10, 217383, 74686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31101, 3, 2, 1, 11, 192440, 3719, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31102, 3, 2, 2, 11, 192440, 7756, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31103, 3, 2, 3, 11, 192440, 11760, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31104, 3, 2, 4, 11, 192440, 15778, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31105, 3, 2, 5, 11, 192440, 19718, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31106, 3, 2, 6, 11, 192440, 23752, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31107, 3, 2, 7, 11, 192440, 29241, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31108, 3, 2, 8, 11, 192440, 33249, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31109, 3, 2, 9, 11, 192440, 37213, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31110, 3, 2, 10, 11, 192440, 41215, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31111, 3, 2, 11, 11, 192440, 45227, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31112, 3, 2, 12, 11, 192440, 49225, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31113, 3, 2, 13, 11, 192440, 54724, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31114, 3, 2, 14, 11, 192440, 58696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31115, 3, 2, 15, 11, 192440, 62696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31116, 3, 2, 16, 11, 192440, 66690, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31117, 3, 2, 17, 11, 192440, 70686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31118, 3, 2, 18, 11, 192440, 74686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31201, 3, 2, 1, 12, 167465, 3719, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31202, 3, 2, 2, 12, 167465, 7756, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31203, 3, 2, 3, 12, 167465, 11760, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31204, 3, 2, 4, 12, 167465, 15778, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31205, 3, 2, 5, 12, 167465, 19718, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31206, 3, 2, 6, 12, 167465, 23752, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31207, 3, 2, 7, 12, 167465, 29241, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31208, 3, 2, 8, 12, 167465, 33249, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31209, 3, 2, 9, 12, 167465, 37213, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31210, 3, 2, 10, 12, 167465, 41215, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31211, 3, 2, 11, 12, 167465, 45227, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31212, 3, 2, 12, 12, 167465, 49225, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31213, 3, 2, 13, 12, 167465, 54724, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31214, 3, 2, 14, 12, 167465, 58696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31215, 3, 2, 15, 12, 167465, 62696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31216, 3, 2, 16, 12, 167465, 66690, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31217, 3, 2, 17, 12, 167465, 70686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31218, 3, 2, 18, 12, 167465, 74686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31301, 3, 2, 1, 13, 142519, 3719, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31302, 3, 2, 2, 13, 142519, 7756, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31303, 3, 2, 3, 13, 142519, 11760, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31304, 3, 2, 4, 13, 142519, 15778, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31305, 3, 2, 5, 13, 142519, 19718, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31306, 3, 2, 6, 13, 142519, 23752, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31307, 3, 2, 7, 13, 142519, 29241, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31308, 3, 2, 8, 13, 142519, 33249, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31309, 3, 2, 9, 13, 142519, 37213, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31310, 3, 2, 10, 13, 142519, 41215, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31311, 3, 2, 11, 13, 142519, 45227, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31312, 3, 2, 12, 13, 142519, 49225, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31313, 3, 2, 13, 13, 142519, 54724, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31314, 3, 2, 14, 13, 142519, 58696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31315, 3, 2, 15, 13, 142519, 62696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31316, 3, 2, 16, 13, 142519, 66690, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31317, 3, 2, 17, 13, 142519, 70686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31318, 3, 2, 18, 13, 142519, 74686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31401, 3, 2, 1, 14, 117551, 3719, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31402, 3, 2, 2, 14, 117551, 7756, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31403, 3, 2, 3, 14, 117551, 11760, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31404, 3, 2, 4, 14, 117551, 15778, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31405, 3, 2, 5, 14, 117551, 19718, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31406, 3, 2, 6, 14, 117551, 23752, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31407, 3, 2, 7, 14, 117551, 29241, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31408, 3, 2, 8, 14, 117551, 33249, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31409, 3, 2, 9, 14, 117551, 37213, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31410, 3, 2, 10, 14, 117551, 41215, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31411, 3, 2, 11, 14, 117551, 45227, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31412, 3, 2, 12, 14, 117551, 49225, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31413, 3, 2, 13, 14, 117551, 54724, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31414, 3, 2, 14, 14, 117551, 58696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31415, 3, 2, 15, 14, 117551, 62696, 0, 1, 2, 0)
GO
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31416, 3, 2, 16, 14, 117551, 66690, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31417, 3, 2, 17, 14, 117551, 70686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31418, 3, 2, 18, 14, 117551, 74686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31501, 3, 2, 1, 15, 92625, 3719, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31502, 3, 2, 2, 15, 92625, 7756, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31503, 3, 2, 3, 15, 92625, 11760, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31504, 3, 2, 4, 15, 92625, 15778, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31505, 3, 2, 5, 15, 92625, 19718, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31506, 3, 2, 6, 15, 92625, 23752, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31507, 3, 2, 7, 15, 92625, 29241, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31508, 3, 2, 8, 15, 92625, 33249, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31509, 3, 2, 9, 15, 92625, 37213, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31510, 3, 2, 10, 15, 92625, 41215, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31511, 3, 2, 11, 15, 92625, 45227, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31512, 3, 2, 12, 15, 92625, 49225, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31513, 3, 2, 13, 15, 92625, 54724, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31514, 3, 2, 14, 15, 92625, 58696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31515, 3, 2, 15, 15, 92625, 62696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31516, 3, 2, 16, 15, 92625, 66690, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31517, 3, 2, 17, 15, 92625, 70686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31518, 3, 2, 18, 15, 92625, 74686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31601, 3, 2, 1, 16, 67666, 3719, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31602, 3, 2, 2, 16, 67666, 7756, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31603, 3, 2, 3, 16, 67666, 11760, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31604, 3, 2, 4, 16, 67666, 15778, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31605, 3, 2, 5, 16, 67666, 19718, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31606, 3, 2, 6, 16, 67666, 23752, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31607, 3, 2, 7, 16, 67666, 29241, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31608, 3, 2, 8, 16, 67666, 33249, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31609, 3, 2, 9, 16, 67666, 37213, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31610, 3, 2, 10, 16, 67666, 41215, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31611, 3, 2, 11, 16, 67666, 45227, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31612, 3, 2, 12, 16, 67666, 49225, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31613, 3, 2, 13, 16, 67666, 54724, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31614, 3, 2, 14, 16, 67666, 58696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31615, 3, 2, 15, 16, 67666, 62696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31616, 3, 2, 16, 16, 67666, 66690, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31617, 3, 2, 17, 16, 67666, 70686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31618, 3, 2, 18, 16, 67666, 74686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31701, 3, 2, 1, 17, 42733, 3719, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31702, 3, 2, 2, 17, 42733, 7756, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31703, 3, 2, 3, 17, 42733, 11760, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31704, 3, 2, 4, 17, 42733, 15778, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31705, 3, 2, 5, 17, 42733, 19718, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31706, 3, 2, 6, 17, 42733, 23752, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31707, 3, 2, 7, 17, 42733, 29241, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31708, 3, 2, 8, 17, 42733, 33249, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31709, 3, 2, 9, 17, 42733, 37213, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31710, 3, 2, 10, 17, 42733, 41215, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31711, 3, 2, 11, 17, 42733, 45227, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31712, 3, 2, 12, 17, 42733, 49225, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31713, 3, 2, 13, 17, 42733, 54724, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31714, 3, 2, 14, 17, 42733, 58696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31715, 3, 2, 15, 17, 42733, 62696, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31716, 3, 2, 16, 17, 42733, 66690, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31717, 3, 2, 17, 17, 42733, 70686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (31718, 3, 2, 18, 17, 42733, 74686, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40101, 4, 2, 1, 1, 441967, 3719, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40102, 4, 2, 2, 1, 441967, 7756, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40103, 4, 2, 3, 1, 441967, 11760, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40104, 4, 2, 4, 1, 441967, 15749, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40105, 4, 2, 5, 1, 441967, 19691, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40106, 4, 2, 6, 1, 441967, 23727, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40107, 4, 2, 7, 1, 441967, 29198, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40108, 4, 2, 8, 1, 441967, 33228, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40109, 4, 2, 9, 1, 441967, 37214, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40110, 4, 2, 10, 1, 441967, 41215, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40111, 4, 2, 11, 1, 441967, 45199, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40112, 4, 2, 12, 1, 441967, 49227, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40113, 4, 2, 13, 1, 441967, 54688, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40114, 4, 2, 14, 1, 441967, 58660, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40115, 4, 2, 15, 1, 441967, 62664, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40116, 4, 2, 16, 1, 441967, 66661, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40117, 4, 2, 17, 1, 441967, 70652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40118, 4, 2, 18, 1, 441967, 74652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40201, 4, 2, 1, 2, 417028, 3719, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40202, 4, 2, 2, 2, 417028, 7756, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40203, 4, 2, 3, 2, 417028, 11760, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40204, 4, 2, 4, 2, 417028, 15749, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40205, 4, 2, 5, 2, 417028, 19691, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40206, 4, 2, 6, 2, 417028, 23727, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40207, 4, 2, 7, 2, 417028, 29198, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40208, 4, 2, 8, 2, 417028, 33228, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40209, 4, 2, 9, 2, 417028, 37214, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40210, 4, 2, 10, 2, 417028, 41215, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40211, 4, 2, 11, 2, 417028, 45199, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40212, 4, 2, 12, 2, 417028, 49227, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40213, 4, 2, 13, 2, 417028, 54688, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40214, 4, 2, 14, 2, 417028, 58660, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40215, 4, 2, 15, 2, 417028, 62664, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40216, 4, 2, 16, 2, 417028, 66661, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40217, 4, 2, 17, 2, 417028, 70652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40218, 4, 2, 18, 2, 417028, 74652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40301, 4, 2, 1, 3, 392102, 3719, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40302, 4, 2, 2, 3, 392102, 7756, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40303, 4, 2, 3, 3, 392102, 11760, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40304, 4, 2, 4, 3, 392102, 15749, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40305, 4, 2, 5, 3, 392102, 19691, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40306, 4, 2, 6, 3, 392102, 23727, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40307, 4, 2, 7, 3, 392102, 29198, 0, 1, 1, 0)
GO
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40308, 4, 2, 8, 3, 392102, 33228, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40309, 4, 2, 9, 3, 392102, 37214, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40310, 4, 2, 10, 3, 392102, 41215, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40311, 4, 2, 11, 3, 392102, 45199, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40312, 4, 2, 12, 3, 392102, 49227, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40313, 4, 2, 13, 3, 392102, 54688, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40314, 4, 2, 14, 3, 392102, 58660, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40315, 4, 2, 15, 3, 392102, 62664, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40316, 4, 2, 16, 3, 392102, 66661, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40317, 4, 2, 17, 3, 392102, 70652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40318, 4, 2, 18, 3, 392102, 74652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40401, 4, 2, 1, 4, 367138, 3719, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40402, 4, 2, 2, 4, 367138, 7756, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40403, 4, 2, 3, 4, 367138, 11760, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40404, 4, 2, 4, 4, 367138, 15749, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40405, 4, 2, 5, 4, 367138, 19691, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40406, 4, 2, 6, 4, 367138, 23727, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40407, 4, 2, 7, 4, 367138, 29198, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40408, 4, 2, 8, 4, 367138, 33228, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40409, 4, 2, 9, 4, 367138, 37214, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40410, 4, 2, 10, 4, 367138, 41215, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40411, 4, 2, 11, 4, 367138, 45199, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40412, 4, 2, 12, 4, 367138, 49227, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40413, 4, 2, 13, 4, 367138, 54688, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40414, 4, 2, 14, 4, 367138, 58660, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40415, 4, 2, 15, 4, 367138, 62664, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40416, 4, 2, 16, 4, 367138, 66661, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40417, 4, 2, 17, 4, 367138, 70652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40418, 4, 2, 18, 4, 367138, 74652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40501, 4, 2, 1, 5, 342217, 3719, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40502, 4, 2, 2, 5, 342217, 7756, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40503, 4, 2, 3, 5, 342217, 11760, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40504, 4, 2, 4, 5, 342217, 15749, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40505, 4, 2, 5, 5, 342217, 19691, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40506, 4, 2, 6, 5, 342217, 23727, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40507, 4, 2, 7, 5, 342217, 29198, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40508, 4, 2, 8, 5, 342217, 33228, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40509, 4, 2, 9, 5, 342217, 37214, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40510, 4, 2, 10, 5, 342217, 41215, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40511, 4, 2, 11, 5, 342217, 45199, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40512, 4, 2, 12, 5, 342217, 49227, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40513, 4, 2, 13, 5, 342217, 54688, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40514, 4, 2, 14, 5, 342217, 58660, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40515, 4, 2, 15, 5, 342217, 62664, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40516, 4, 2, 16, 5, 342217, 66661, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40517, 4, 2, 17, 5, 342217, 70652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40518, 4, 2, 18, 5, 342217, 74652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40601, 4, 2, 1, 6, 317269, 3719, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40602, 4, 2, 2, 6, 317269, 7756, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40603, 4, 2, 3, 6, 317269, 11760, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40604, 4, 2, 4, 6, 317269, 15749, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40605, 4, 2, 5, 6, 317269, 19691, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40606, 4, 2, 6, 6, 317269, 23727, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40607, 4, 2, 7, 6, 317269, 29198, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40608, 4, 2, 8, 6, 317269, 33228, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40609, 4, 2, 9, 6, 317269, 37214, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40610, 4, 2, 10, 6, 317269, 41215, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40611, 4, 2, 11, 6, 317269, 45199, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40612, 4, 2, 12, 6, 317269, 49227, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40613, 4, 2, 13, 6, 317269, 54688, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40614, 4, 2, 14, 6, 317269, 58660, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40615, 4, 2, 15, 6, 317269, 62664, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40616, 4, 2, 16, 6, 317269, 66661, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40617, 4, 2, 17, 6, 317269, 70652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40618, 4, 2, 18, 6, 317269, 74652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40701, 4, 2, 1, 7, 292302, 3719, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40702, 4, 2, 2, 7, 292302, 7756, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40703, 4, 2, 3, 7, 292302, 11760, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40704, 4, 2, 4, 7, 292302, 15749, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40705, 4, 2, 5, 7, 292302, 19691, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40706, 4, 2, 6, 7, 292302, 23727, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40707, 4, 2, 7, 7, 292302, 29198, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40708, 4, 2, 8, 7, 292302, 33228, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40709, 4, 2, 9, 7, 292302, 37214, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40710, 4, 2, 10, 7, 292302, 41215, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40711, 4, 2, 11, 7, 292302, 45199, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40712, 4, 2, 12, 7, 292302, 49227, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40713, 4, 2, 13, 7, 292302, 54688, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40714, 4, 2, 14, 7, 292302, 58660, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40715, 4, 2, 15, 7, 292302, 62664, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40716, 4, 2, 16, 7, 292302, 66661, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40717, 4, 2, 17, 7, 292302, 70652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40718, 4, 2, 18, 7, 292302, 74652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40801, 4, 2, 1, 8, 267322, 3719, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40802, 4, 2, 2, 8, 267322, 7756, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40803, 4, 2, 3, 8, 267322, 11760, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40804, 4, 2, 4, 8, 267322, 15749, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40805, 4, 2, 5, 8, 267322, 19691, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40806, 4, 2, 6, 8, 267322, 23727, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40807, 4, 2, 7, 8, 267322, 29198, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40808, 4, 2, 8, 8, 267322, 33228, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40809, 4, 2, 9, 8, 267322, 37214, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40810, 4, 2, 10, 8, 267322, 41215, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40811, 4, 2, 11, 8, 267322, 45199, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40812, 4, 2, 12, 8, 267322, 49227, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40813, 4, 2, 13, 8, 267322, 54688, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40814, 4, 2, 14, 8, 267322, 58660, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40815, 4, 2, 15, 8, 267322, 62664, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40816, 4, 2, 16, 8, 267322, 66661, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40817, 4, 2, 17, 8, 267322, 70652, 0, 1, 1, 0)
GO
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40818, 4, 2, 18, 8, 267322, 74652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40901, 4, 2, 1, 9, 242395, 3719, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40902, 4, 2, 2, 9, 242395, 7756, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40903, 4, 2, 3, 9, 242395, 11760, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40904, 4, 2, 4, 9, 242395, 15749, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40905, 4, 2, 5, 9, 242395, 19691, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40906, 4, 2, 6, 9, 242395, 23727, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40907, 4, 2, 7, 9, 242395, 29198, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40908, 4, 2, 8, 9, 242395, 33228, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40909, 4, 2, 9, 9, 242395, 37214, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40910, 4, 2, 10, 9, 242395, 41215, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40911, 4, 2, 11, 9, 242395, 45199, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40912, 4, 2, 12, 9, 242395, 49227, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40913, 4, 2, 13, 9, 242395, 54688, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40914, 4, 2, 14, 9, 242395, 58660, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40915, 4, 2, 15, 9, 242395, 62664, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40916, 4, 2, 16, 9, 242395, 66661, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40917, 4, 2, 17, 9, 242395, 70652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (40918, 4, 2, 18, 9, 242395, 74652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41001, 4, 2, 1, 10, 217452, 3719, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41002, 4, 2, 2, 10, 217452, 7756, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41003, 4, 2, 3, 10, 217452, 11760, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41004, 4, 2, 4, 10, 217452, 15749, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41005, 4, 2, 5, 10, 217452, 19691, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41006, 4, 2, 6, 10, 217452, 23727, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41007, 4, 2, 7, 10, 217452, 29198, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41008, 4, 2, 8, 10, 217452, 33228, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41009, 4, 2, 9, 10, 217452, 37214, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41010, 4, 2, 10, 10, 217452, 41215, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41011, 4, 2, 11, 10, 217452, 45199, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41012, 4, 2, 12, 10, 217452, 49227, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41013, 4, 2, 13, 10, 217452, 54688, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41014, 4, 2, 14, 10, 217452, 58660, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41015, 4, 2, 15, 10, 217452, 62664, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41016, 4, 2, 16, 10, 217452, 66661, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41017, 4, 2, 17, 10, 217452, 70652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41018, 4, 2, 18, 10, 217452, 74652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41101, 4, 2, 1, 11, 192496, 3719, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41102, 4, 2, 2, 11, 192496, 7756, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41103, 4, 2, 3, 11, 192496, 11760, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41104, 4, 2, 4, 11, 192496, 15749, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41105, 4, 2, 5, 11, 192496, 19691, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41106, 4, 2, 6, 11, 192496, 23727, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41107, 4, 2, 7, 11, 192496, 29198, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41108, 4, 2, 8, 11, 192496, 33228, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41109, 4, 2, 9, 11, 192496, 37214, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41110, 4, 2, 10, 11, 192496, 41215, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41111, 4, 2, 11, 11, 192496, 45199, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41112, 4, 2, 12, 11, 192496, 49227, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41113, 4, 2, 13, 11, 192496, 54688, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41114, 4, 2, 14, 11, 192496, 58660, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41115, 4, 2, 15, 11, 192496, 62664, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41116, 4, 2, 16, 11, 192496, 66661, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41117, 4, 2, 17, 11, 192496, 70652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41118, 4, 2, 18, 11, 192496, 74652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41201, 4, 2, 1, 12, 167568, 3719, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41202, 4, 2, 2, 12, 167568, 7756, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41203, 4, 2, 3, 12, 167568, 11760, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41204, 4, 2, 4, 12, 167568, 15749, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41205, 4, 2, 5, 12, 167568, 19691, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41206, 4, 2, 6, 12, 167568, 23727, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41207, 4, 2, 7, 12, 167568, 29198, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41208, 4, 2, 8, 12, 167568, 33228, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41209, 4, 2, 9, 12, 167568, 37214, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41210, 4, 2, 10, 12, 167568, 41215, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41211, 4, 2, 11, 12, 167568, 45199, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41212, 4, 2, 12, 12, 167568, 49227, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41213, 4, 2, 13, 12, 167568, 54688, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41214, 4, 2, 14, 12, 167568, 58660, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41215, 4, 2, 15, 12, 167568, 62664, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41216, 4, 2, 16, 12, 167568, 66661, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41217, 4, 2, 17, 12, 167568, 70652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41218, 4, 2, 18, 12, 167568, 74652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41301, 4, 2, 1, 13, 142602, 3719, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41302, 4, 2, 2, 13, 142602, 7756, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41303, 4, 2, 3, 13, 142602, 11760, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41304, 4, 2, 4, 13, 142602, 15749, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41305, 4, 2, 5, 13, 142602, 19691, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41306, 4, 2, 6, 13, 142602, 23727, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41307, 4, 2, 7, 13, 142602, 29198, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41308, 4, 2, 8, 13, 142602, 33228, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41309, 4, 2, 9, 13, 142602, 37214, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41310, 4, 2, 10, 13, 142602, 41215, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41311, 4, 2, 11, 13, 142602, 45199, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41312, 4, 2, 12, 13, 142602, 49227, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41313, 4, 2, 13, 13, 142602, 54688, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41314, 4, 2, 14, 13, 142602, 58660, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41315, 4, 2, 15, 13, 142602, 62664, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41316, 4, 2, 16, 13, 142602, 66661, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41317, 4, 2, 17, 13, 142602, 70652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41318, 4, 2, 18, 13, 142602, 74652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41401, 4, 2, 1, 14, 117649, 3719, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41402, 4, 2, 2, 14, 117649, 7756, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41403, 4, 2, 3, 14, 117649, 11760, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41404, 4, 2, 4, 14, 117649, 15749, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41405, 4, 2, 5, 14, 117649, 19691, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41406, 4, 2, 6, 14, 117649, 23727, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41407, 4, 2, 7, 14, 117649, 29198, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41408, 4, 2, 8, 14, 117649, 33228, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41409, 4, 2, 9, 14, 117649, 37214, 0, 1, 1, 0)
GO
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41410, 4, 2, 10, 14, 117649, 41215, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41411, 4, 2, 11, 14, 117649, 45199, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41412, 4, 2, 12, 14, 117649, 49227, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41413, 4, 2, 13, 14, 117649, 54688, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41414, 4, 2, 14, 14, 117649, 58660, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41415, 4, 2, 15, 14, 117649, 62664, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41416, 4, 2, 16, 14, 117649, 66661, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41417, 4, 2, 17, 14, 117649, 70652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41418, 4, 2, 18, 14, 117649, 74652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41501, 4, 2, 1, 15, 92705, 3719, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41502, 4, 2, 2, 15, 92705, 7756, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41503, 4, 2, 3, 15, 92705, 11760, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41504, 4, 2, 4, 15, 92705, 15749, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41505, 4, 2, 5, 15, 92705, 19691, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41506, 4, 2, 6, 15, 92705, 23727, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41507, 4, 2, 7, 15, 92705, 29198, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41508, 4, 2, 8, 15, 92705, 33228, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41509, 4, 2, 9, 15, 92705, 37214, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41510, 4, 2, 10, 15, 92705, 41215, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41511, 4, 2, 11, 15, 92705, 45199, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41512, 4, 2, 12, 15, 92705, 49227, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41513, 4, 2, 13, 15, 92705, 54688, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41514, 4, 2, 14, 15, 92705, 58660, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41515, 4, 2, 15, 15, 92705, 62664, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41516, 4, 2, 16, 15, 92705, 66661, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41517, 4, 2, 17, 15, 92705, 70652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41518, 4, 2, 18, 15, 92705, 74652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41601, 4, 2, 1, 16, 67742, 3719, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41602, 4, 2, 2, 16, 67742, 7756, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41603, 4, 2, 3, 16, 67742, 11760, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41604, 4, 2, 4, 16, 67742, 15749, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41605, 4, 2, 5, 16, 67742, 19691, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41606, 4, 2, 6, 16, 67742, 23727, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41607, 4, 2, 7, 16, 67742, 29198, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41608, 4, 2, 8, 16, 67742, 33228, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41609, 4, 2, 9, 16, 67742, 37214, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41610, 4, 2, 10, 16, 67742, 41215, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41611, 4, 2, 11, 16, 67742, 45199, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41612, 4, 2, 12, 16, 67742, 49227, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41613, 4, 2, 13, 16, 67742, 54688, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41614, 4, 2, 14, 16, 67742, 58660, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41615, 4, 2, 15, 16, 67742, 62664, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41616, 4, 2, 16, 16, 67742, 66661, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41617, 4, 2, 17, 16, 67742, 70652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41618, 4, 2, 18, 16, 67742, 74652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41701, 4, 2, 1, 17, 42801, 3719, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41702, 4, 2, 2, 17, 42801, 7756, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41703, 4, 2, 3, 17, 42801, 11760, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41704, 4, 2, 4, 17, 42801, 15749, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41705, 4, 2, 5, 17, 42801, 19691, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41706, 4, 2, 6, 17, 42801, 23727, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41707, 4, 2, 7, 17, 42801, 29198, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41708, 4, 2, 8, 17, 42801, 33228, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41709, 4, 2, 9, 17, 42801, 37214, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41710, 4, 2, 10, 17, 42801, 41215, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41711, 4, 2, 11, 17, 42801, 45199, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41712, 4, 2, 12, 17, 42801, 49227, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41713, 4, 2, 13, 17, 42801, 54688, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41714, 4, 2, 14, 17, 42801, 58660, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41715, 4, 2, 15, 17, 42801, 62664, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41716, 4, 2, 16, 17, 42801, 66661, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41717, 4, 2, 17, 17, 42801, 70652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (41718, 4, 2, 18, 17, 42801, 74652, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50101, 5, 3, 1, 1, 441852, 3519, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50102, 5, 3, 2, 1, 441830, 7525, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50103, 5, 3, 3, 1, 441808, 11533, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50104, 5, 3, 4, 1, 441786, 15556, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50105, 5, 3, 5, 1, 441764, 19557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50106, 5, 3, 6, 1, 441742, 23557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50107, 5, 3, 7, 1, 441720, 29055, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50108, 5, 3, 8, 1, 441698, 33074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50109, 5, 3, 9, 1, 441676, 37074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50110, 5, 3, 10, 1, 441654, 41077, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50111, 5, 3, 11, 1, 441632, 45106, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50112, 5, 3, 12, 1, 441610, 49143, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50113, 5, 3, 13, 1, 441588, 54624, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50114, 5, 3, 14, 1, 441566, 58603, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50115, 5, 3, 15, 1, 441544, 62605, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50116, 5, 3, 16, 1, 441522, 66601, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50117, 5, 3, 17, 1, 441500, 70620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50118, 5, 3, 18, 1, 441478, 74620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50201, 5, 3, 1, 2, 416906, 3519, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50202, 5, 3, 2, 2, 416884, 7525, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50203, 5, 3, 3, 2, 416862, 11533, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50204, 5, 3, 4, 2, 416840, 15556, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50205, 5, 3, 5, 2, 416818, 19557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50206, 5, 3, 6, 2, 416796, 23557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50207, 5, 3, 7, 2, 416774, 29055, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50208, 5, 3, 8, 2, 416752, 33074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50209, 5, 3, 9, 2, 416730, 37074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50210, 5, 3, 10, 2, 416708, 41077, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50211, 5, 3, 11, 2, 416686, 45106, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50212, 5, 3, 12, 2, 416664, 49143, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50213, 5, 3, 13, 2, 416642, 54624, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50214, 5, 3, 14, 2, 416620, 58603, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50215, 5, 3, 15, 2, 416598, 62605, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50216, 5, 3, 16, 2, 416576, 66601, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50217, 5, 3, 17, 2, 416554, 70620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50218, 5, 3, 18, 2, 416532, 74620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50301, 5, 3, 1, 3, 391974, 3519, 0, 1, 2, 0)
GO
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50302, 5, 3, 2, 3, 391952, 7525, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50303, 5, 3, 3, 3, 391930, 11533, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50304, 5, 3, 4, 3, 391908, 15556, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50305, 5, 3, 5, 3, 391886, 19557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50306, 5, 3, 6, 3, 391864, 23557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50307, 5, 3, 7, 3, 391842, 29055, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50308, 5, 3, 8, 3, 391820, 33074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50309, 5, 3, 9, 3, 391798, 37074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50310, 5, 3, 10, 3, 391776, 41077, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50311, 5, 3, 11, 3, 391754, 45106, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50312, 5, 3, 12, 3, 391732, 49143, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50313, 5, 3, 13, 3, 391710, 54624, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50314, 5, 3, 14, 3, 391688, 58603, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50315, 5, 3, 15, 3, 391666, 62605, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50316, 5, 3, 16, 3, 391644, 66601, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50317, 5, 3, 17, 3, 391622, 70620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50318, 5, 3, 18, 3, 391600, 74620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50401, 5, 3, 1, 4, 367012, 3519, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50402, 5, 3, 2, 4, 366990, 7525, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50403, 5, 3, 3, 4, 366968, 11533, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50404, 5, 3, 4, 4, 366946, 15556, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50405, 5, 3, 5, 4, 366924, 19557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50406, 5, 3, 6, 4, 366902, 23557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50407, 5, 3, 7, 4, 366880, 29055, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50408, 5, 3, 8, 4, 366858, 33074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50409, 5, 3, 9, 4, 366836, 37074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50410, 5, 3, 10, 4, 366814, 41077, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50411, 5, 3, 11, 4, 366792, 45106, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50412, 5, 3, 12, 4, 366770, 49143, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50413, 5, 3, 13, 4, 366748, 54624, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50414, 5, 3, 14, 4, 366726, 58603, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50415, 5, 3, 15, 4, 366704, 62605, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50416, 5, 3, 16, 4, 366682, 66601, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50417, 5, 3, 17, 4, 366660, 70620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50418, 5, 3, 18, 4, 366638, 74620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50501, 5, 3, 1, 5, 342068, 3519, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50502, 5, 3, 2, 5, 342046, 7525, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50503, 5, 3, 3, 5, 342024, 11533, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50504, 5, 3, 4, 5, 342002, 15556, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50505, 5, 3, 5, 5, 341980, 19557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50506, 5, 3, 6, 5, 341958, 23557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50507, 5, 3, 7, 5, 341936, 29055, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50508, 5, 3, 8, 5, 341914, 33074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50509, 5, 3, 9, 5, 341892, 37074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50510, 5, 3, 10, 5, 341870, 41077, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50511, 5, 3, 11, 5, 341848, 45106, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50512, 5, 3, 12, 5, 341826, 49143, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50513, 5, 3, 13, 5, 341804, 54624, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50514, 5, 3, 14, 5, 341782, 58603, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50515, 5, 3, 15, 5, 341760, 62605, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50516, 5, 3, 16, 5, 341738, 66601, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50517, 5, 3, 17, 5, 341716, 70620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50518, 5, 3, 18, 5, 341694, 74620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50601, 5, 3, 1, 6, 317121, 3519, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50602, 5, 3, 2, 6, 317099, 7525, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50603, 5, 3, 3, 6, 317077, 11533, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50604, 5, 3, 4, 6, 317055, 15556, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50605, 5, 3, 5, 6, 317033, 19557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50606, 5, 3, 6, 6, 317011, 23557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50607, 5, 3, 7, 6, 316989, 29055, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50608, 5, 3, 8, 6, 316967, 33074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50609, 5, 3, 9, 6, 316945, 37074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50610, 5, 3, 10, 6, 316923, 41077, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50611, 5, 3, 11, 6, 316901, 45106, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50612, 5, 3, 12, 6, 316879, 49143, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50613, 5, 3, 13, 6, 316857, 54624, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50614, 5, 3, 14, 6, 316835, 58603, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50615, 5, 3, 15, 6, 316813, 62605, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50616, 5, 3, 16, 6, 316791, 66601, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50617, 5, 3, 17, 6, 316769, 70620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50618, 5, 3, 18, 6, 316747, 74620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50701, 5, 3, 1, 7, 292188, 3519, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50702, 5, 3, 2, 7, 292166, 7525, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50703, 5, 3, 3, 7, 292144, 11533, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50704, 5, 3, 4, 7, 292122, 15556, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50705, 5, 3, 5, 7, 292100, 19557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50706, 5, 3, 6, 7, 292078, 23557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50707, 5, 3, 7, 7, 292056, 29055, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50708, 5, 3, 8, 7, 292034, 33074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50709, 5, 3, 9, 7, 292012, 37074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50710, 5, 3, 10, 7, 291990, 41077, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50711, 5, 3, 11, 7, 291968, 45106, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50712, 5, 3, 12, 7, 291946, 49143, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50713, 5, 3, 13, 7, 291924, 54624, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50714, 5, 3, 14, 7, 291902, 58603, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50715, 5, 3, 15, 7, 291880, 62605, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50716, 5, 3, 16, 7, 291858, 66601, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50717, 5, 3, 17, 7, 291836, 70620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50718, 5, 3, 18, 7, 291814, 74620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50801, 5, 3, 1, 8, 267232, 3519, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50802, 5, 3, 2, 8, 267210, 7525, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50803, 5, 3, 3, 8, 267188, 11533, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50804, 5, 3, 4, 8, 267166, 15556, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50805, 5, 3, 5, 8, 267144, 19557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50806, 5, 3, 6, 8, 267122, 23557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50807, 5, 3, 7, 8, 267100, 29055, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50808, 5, 3, 8, 8, 267078, 33074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50809, 5, 3, 9, 8, 267056, 37074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50810, 5, 3, 10, 8, 267034, 41077, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50811, 5, 3, 11, 8, 267012, 45106, 0, 1, 2, 0)
GO
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50812, 5, 3, 12, 8, 266990, 49143, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50813, 5, 3, 13, 8, 266968, 54624, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50814, 5, 3, 14, 8, 266946, 58603, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50815, 5, 3, 15, 8, 266924, 62605, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50816, 5, 3, 16, 8, 266902, 66601, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50817, 5, 3, 17, 8, 266880, 70620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50818, 5, 3, 18, 8, 266858, 74620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50901, 5, 3, 1, 9, 242266, 3519, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50902, 5, 3, 2, 9, 242244, 7525, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50903, 5, 3, 3, 9, 242222, 11533, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50904, 5, 3, 4, 9, 242200, 15556, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50905, 5, 3, 5, 9, 242178, 19557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50906, 5, 3, 6, 9, 242156, 23557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50907, 5, 3, 7, 9, 242134, 29055, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50908, 5, 3, 8, 9, 242112, 33074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50909, 5, 3, 9, 9, 242090, 37074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50910, 5, 3, 10, 9, 242068, 41077, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50911, 5, 3, 11, 9, 242046, 45106, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50912, 5, 3, 12, 9, 242024, 49143, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50913, 5, 3, 13, 9, 242002, 54624, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50914, 5, 3, 14, 9, 241980, 58603, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50915, 5, 3, 15, 9, 241958, 62605, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50916, 5, 3, 16, 9, 241936, 66601, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50917, 5, 3, 17, 9, 241914, 70620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (50918, 5, 3, 18, 9, 241892, 74620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51001, 5, 3, 1, 10, 217324, 3519, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51002, 5, 3, 2, 10, 217302, 7525, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51003, 5, 3, 3, 10, 217280, 11533, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51004, 5, 3, 4, 10, 217258, 15556, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51005, 5, 3, 5, 10, 217236, 19557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51006, 5, 3, 6, 10, 217214, 23557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51007, 5, 3, 7, 10, 217192, 29055, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51008, 5, 3, 8, 10, 217170, 33074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51009, 5, 3, 9, 10, 217148, 37074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51010, 5, 3, 10, 10, 217126, 41077, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51011, 5, 3, 11, 10, 217104, 45106, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51012, 5, 3, 12, 10, 217082, 49143, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51013, 5, 3, 13, 10, 217060, 54624, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51014, 5, 3, 14, 10, 217038, 58603, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51015, 5, 3, 15, 10, 217016, 62605, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51016, 5, 3, 16, 10, 216994, 66601, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51017, 5, 3, 17, 10, 216972, 70620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51018, 5, 3, 18, 10, 216950, 74620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51101, 5, 3, 1, 11, 192339, 3519, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51102, 5, 3, 2, 11, 192317, 7525, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51103, 5, 3, 3, 11, 192295, 11533, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51104, 5, 3, 4, 11, 192273, 15556, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51105, 5, 3, 5, 11, 192251, 19557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51106, 5, 3, 6, 11, 192229, 23557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51107, 5, 3, 7, 11, 192207, 29055, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51108, 5, 3, 8, 11, 192185, 33074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51109, 5, 3, 9, 11, 192163, 37074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51110, 5, 3, 10, 11, 192141, 41077, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51111, 5, 3, 11, 11, 192119, 45106, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51112, 5, 3, 12, 11, 192097, 49143, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51113, 5, 3, 13, 11, 192075, 54624, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51114, 5, 3, 14, 11, 192053, 58603, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51115, 5, 3, 15, 11, 192031, 62605, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51116, 5, 3, 16, 11, 192009, 66601, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51117, 5, 3, 17, 11, 191987, 70620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51118, 5, 3, 18, 11, 191965, 74620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51201, 5, 3, 1, 12, 167399, 3519, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51202, 5, 3, 2, 12, 167377, 7525, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51203, 5, 3, 3, 12, 167355, 11533, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51204, 5, 3, 4, 12, 167333, 15556, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51205, 5, 3, 5, 12, 167311, 19557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51206, 5, 3, 6, 12, 167289, 23557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51207, 5, 3, 7, 12, 167267, 29055, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51208, 5, 3, 8, 12, 167245, 33074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51209, 5, 3, 9, 12, 167223, 37074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51210, 5, 3, 10, 12, 167201, 41077, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51211, 5, 3, 11, 12, 167179, 45106, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51212, 5, 3, 12, 12, 167157, 49143, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51213, 5, 3, 13, 12, 167135, 54624, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51214, 5, 3, 14, 12, 167113, 58603, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51215, 5, 3, 15, 12, 167091, 62605, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51216, 5, 3, 16, 12, 167069, 66601, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51217, 5, 3, 17, 12, 167047, 70620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51218, 5, 3, 18, 12, 167025, 74620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51301, 5, 3, 1, 13, 142471, 3519, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51302, 5, 3, 2, 13, 142449, 7525, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51303, 5, 3, 3, 13, 142427, 11533, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51304, 5, 3, 4, 13, 142405, 15556, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51305, 5, 3, 5, 13, 142383, 19557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51306, 5, 3, 6, 13, 142361, 23557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51307, 5, 3, 7, 13, 142339, 29055, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51308, 5, 3, 8, 13, 142317, 33074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51309, 5, 3, 9, 13, 142295, 37074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51310, 5, 3, 10, 13, 142273, 41077, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51311, 5, 3, 11, 13, 142251, 45106, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51312, 5, 3, 12, 13, 142229, 49143, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51313, 5, 3, 13, 13, 142207, 54624, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51314, 5, 3, 14, 13, 142185, 58603, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51315, 5, 3, 15, 13, 142163, 62605, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51316, 5, 3, 16, 13, 142141, 66601, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51317, 5, 3, 17, 13, 142119, 70620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51318, 5, 3, 18, 13, 142097, 74620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51401, 5, 3, 1, 14, 117528, 3519, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51402, 5, 3, 2, 14, 117506, 7525, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51403, 5, 3, 3, 14, 117484, 11533, 0, 1, 2, 0)
GO
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51404, 5, 3, 4, 14, 117462, 15556, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51405, 5, 3, 5, 14, 117440, 19557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51406, 5, 3, 6, 14, 117418, 23557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51407, 5, 3, 7, 14, 117396, 29055, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51408, 5, 3, 8, 14, 117374, 33074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51409, 5, 3, 9, 14, 117352, 37074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51410, 5, 3, 10, 14, 117330, 41077, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51411, 5, 3, 11, 14, 117308, 45106, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51412, 5, 3, 12, 14, 117286, 49143, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51413, 5, 3, 13, 14, 117264, 54624, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51414, 5, 3, 14, 14, 117242, 58603, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51415, 5, 3, 15, 14, 117220, 62605, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51416, 5, 3, 16, 14, 117198, 66601, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51417, 5, 3, 17, 14, 117176, 70620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51418, 5, 3, 18, 14, 117154, 74620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51501, 5, 3, 1, 15, 92556, 3519, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51502, 5, 3, 2, 15, 92534, 7525, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51503, 5, 3, 3, 15, 92512, 11533, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51504, 5, 3, 4, 15, 92490, 15556, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51505, 5, 3, 5, 15, 92468, 19557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51506, 5, 3, 6, 15, 92446, 23557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51507, 5, 3, 7, 15, 92424, 29055, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51508, 5, 3, 8, 15, 92402, 33074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51509, 5, 3, 9, 15, 92380, 37074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51510, 5, 3, 10, 15, 92358, 41077, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51511, 5, 3, 11, 15, 92336, 45106, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51512, 5, 3, 12, 15, 92314, 49143, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51513, 5, 3, 13, 15, 92292, 54624, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51514, 5, 3, 14, 15, 92270, 58603, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51515, 5, 3, 15, 15, 92248, 62605, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51516, 5, 3, 16, 15, 92226, 66601, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51517, 5, 3, 17, 15, 92204, 70620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51518, 5, 3, 18, 15, 92182, 74620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51601, 5, 3, 1, 16, 67548, 3519, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51602, 5, 3, 2, 16, 67526, 7525, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51603, 5, 3, 3, 16, 67504, 11533, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51604, 5, 3, 4, 16, 67482, 15556, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51605, 5, 3, 5, 16, 67460, 19557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51606, 5, 3, 6, 16, 67438, 23557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51607, 5, 3, 7, 16, 67416, 29055, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51608, 5, 3, 8, 16, 67394, 33074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51609, 5, 3, 9, 16, 67372, 37074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51610, 5, 3, 10, 16, 67350, 41077, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51611, 5, 3, 11, 16, 67328, 45106, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51612, 5, 3, 12, 16, 67306, 49143, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51613, 5, 3, 13, 16, 67284, 54624, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51614, 5, 3, 14, 16, 67262, 58603, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51615, 5, 3, 15, 16, 67240, 62605, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51616, 5, 3, 16, 16, 67218, 66601, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51617, 5, 3, 17, 16, 67196, 70620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51618, 5, 3, 18, 16, 67174, 74620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51701, 5, 3, 1, 17, 42665, 3519, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51702, 5, 3, 2, 17, 42643, 7525, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51703, 5, 3, 3, 17, 42621, 11533, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51704, 5, 3, 4, 17, 42599, 15556, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51705, 5, 3, 5, 17, 42577, 19557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51706, 5, 3, 6, 17, 42555, 23557, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51707, 5, 3, 7, 17, 42533, 29055, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51708, 5, 3, 8, 17, 42511, 33074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51709, 5, 3, 9, 17, 42489, 37074, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51710, 5, 3, 10, 17, 42467, 41077, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51711, 5, 3, 11, 17, 42445, 45106, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51712, 5, 3, 12, 17, 42423, 49143, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51713, 5, 3, 13, 17, 42401, 54624, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51714, 5, 3, 14, 17, 42379, 58603, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51715, 5, 3, 15, 17, 42357, 62605, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51716, 5, 3, 16, 17, 42335, 66601, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51717, 5, 3, 17, 17, 42313, 70620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (51718, 5, 3, 18, 17, 42291, 74620, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60101, 6, 3, 1, 1, 441874, 3554, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60102, 6, 3, 2, 1, 441874, 7556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60103, 6, 3, 3, 1, 441874, 11541, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60104, 6, 3, 4, 1, 441874, 15556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60105, 6, 3, 5, 1, 441874, 19557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60106, 6, 3, 6, 1, 441874, 23557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60107, 6, 3, 7, 1, 441847, 29094, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60108, 6, 3, 8, 1, 441820, 33112, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60109, 6, 3, 9, 1, 441793, 37086, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60110, 6, 3, 10, 1, 441766, 41132, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60111, 6, 3, 11, 1, 441739, 45143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60112, 6, 3, 12, 1, 441712, 49143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60113, 6, 3, 13, 1, 441685, 54677, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60114, 6, 3, 14, 1, 441658, 58666, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60115, 6, 3, 15, 1, 441631, 62651, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60116, 6, 3, 16, 1, 441604, 66693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60117, 6, 3, 17, 1, 441577, 70693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60118, 6, 3, 18, 1, 441550, 74693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60201, 6, 3, 1, 2, 416915, 3554, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60202, 6, 3, 2, 2, 416915, 7556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60203, 6, 3, 3, 2, 416915, 11541, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60204, 6, 3, 4, 2, 416915, 15556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60205, 6, 3, 5, 2, 416915, 19557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60206, 6, 3, 6, 2, 416915, 23557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60207, 6, 3, 7, 2, 416888, 29094, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60208, 6, 3, 8, 2, 416861, 33112, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60209, 6, 3, 9, 2, 416834, 37086, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60210, 6, 3, 10, 2, 416807, 41132, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60211, 6, 3, 11, 2, 416780, 45143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60212, 6, 3, 12, 2, 416753, 49143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60213, 6, 3, 13, 2, 416726, 54677, 0, 1, 1, 0)
GO
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60214, 6, 3, 14, 2, 416699, 58666, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60215, 6, 3, 15, 2, 416672, 62651, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60216, 6, 3, 16, 2, 416645, 66693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60217, 6, 3, 17, 2, 416618, 70693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60218, 6, 3, 18, 2, 416591, 74693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60301, 6, 3, 1, 3, 391978, 3554, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60302, 6, 3, 2, 3, 391978, 7556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60303, 6, 3, 3, 3, 391978, 11541, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60304, 6, 3, 4, 3, 391978, 15556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60305, 6, 3, 5, 3, 391978, 19557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60306, 6, 3, 6, 3, 391978, 23557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60307, 6, 3, 7, 3, 391951, 29094, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60308, 6, 3, 8, 3, 391924, 33112, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60309, 6, 3, 9, 3, 391897, 37086, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60310, 6, 3, 10, 3, 391870, 41132, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60311, 6, 3, 11, 3, 391843, 45143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60312, 6, 3, 12, 3, 391816, 49143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60313, 6, 3, 13, 3, 391789, 54677, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60314, 6, 3, 14, 3, 391762, 58666, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60315, 6, 3, 15, 3, 391735, 62651, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60316, 6, 3, 16, 3, 391708, 66693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60317, 6, 3, 17, 3, 391681, 70693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60318, 6, 3, 18, 3, 391654, 74693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60401, 6, 3, 1, 4, 366991, 3554, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60402, 6, 3, 2, 4, 366991, 7556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60403, 6, 3, 3, 4, 366991, 11541, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60404, 6, 3, 4, 4, 366991, 15556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60405, 6, 3, 5, 4, 366991, 19557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60406, 6, 3, 6, 4, 366991, 23557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60407, 6, 3, 7, 4, 366964, 29094, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60408, 6, 3, 8, 4, 366937, 33112, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60409, 6, 3, 9, 4, 366910, 37086, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60410, 6, 3, 10, 4, 366883, 41132, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60411, 6, 3, 11, 4, 366856, 45143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60412, 6, 3, 12, 4, 366829, 49143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60413, 6, 3, 13, 4, 366802, 54677, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60414, 6, 3, 14, 4, 366775, 58666, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60415, 6, 3, 15, 4, 366748, 62651, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60416, 6, 3, 16, 4, 366721, 66693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60417, 6, 3, 17, 4, 366694, 70693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60418, 6, 3, 18, 4, 366667, 74693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60501, 6, 3, 1, 5, 342045, 3554, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60502, 6, 3, 2, 5, 342045, 7556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60503, 6, 3, 3, 5, 342045, 11541, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60504, 6, 3, 4, 5, 342045, 15556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60505, 6, 3, 5, 5, 342045, 19557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60506, 6, 3, 6, 5, 342045, 23557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60507, 6, 3, 7, 5, 342018, 29094, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60508, 6, 3, 8, 5, 341991, 33112, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60509, 6, 3, 9, 5, 341964, 37086, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60510, 6, 3, 10, 5, 341937, 41132, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60511, 6, 3, 11, 5, 341910, 45143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60512, 6, 3, 12, 5, 341883, 49143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60513, 6, 3, 13, 5, 341856, 54677, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60514, 6, 3, 14, 5, 341829, 58666, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60515, 6, 3, 15, 5, 341802, 62651, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60516, 6, 3, 16, 5, 341775, 66693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60517, 6, 3, 17, 5, 341748, 70693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60518, 6, 3, 18, 5, 341721, 74693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60601, 6, 3, 1, 6, 317090, 3554, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60602, 6, 3, 2, 6, 317090, 7556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60603, 6, 3, 3, 6, 317090, 11541, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60604, 6, 3, 4, 6, 317090, 15556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60605, 6, 3, 5, 6, 317090, 19557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60606, 6, 3, 6, 6, 317090, 23557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60607, 6, 3, 7, 6, 317063, 29094, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60608, 6, 3, 8, 6, 317036, 33112, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60609, 6, 3, 9, 6, 317009, 37086, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60610, 6, 3, 10, 6, 316982, 41132, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60611, 6, 3, 11, 6, 316955, 45143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60612, 6, 3, 12, 6, 316928, 49143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60613, 6, 3, 13, 6, 316901, 54677, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60614, 6, 3, 14, 6, 316874, 58666, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60615, 6, 3, 15, 6, 316847, 62651, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60616, 6, 3, 16, 6, 316820, 66693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60617, 6, 3, 17, 6, 316793, 70693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60618, 6, 3, 18, 6, 316766, 74693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60701, 6, 3, 1, 7, 292132, 3554, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60702, 6, 3, 2, 7, 292132, 7556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60703, 6, 3, 3, 7, 292132, 11541, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60704, 6, 3, 4, 7, 292132, 15556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60705, 6, 3, 5, 7, 292132, 19557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60706, 6, 3, 6, 7, 292132, 23557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60707, 6, 3, 7, 7, 292105, 29094, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60708, 6, 3, 8, 7, 292078, 33112, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60709, 6, 3, 9, 7, 292051, 37086, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60710, 6, 3, 10, 7, 292024, 41132, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60711, 6, 3, 11, 7, 291997, 45143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60712, 6, 3, 12, 7, 291970, 49143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60713, 6, 3, 13, 7, 291943, 54677, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60714, 6, 3, 14, 7, 291916, 58666, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60715, 6, 3, 15, 7, 291889, 62651, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60716, 6, 3, 16, 7, 291862, 66693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60717, 6, 3, 17, 7, 291835, 70693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60718, 6, 3, 18, 7, 291808, 74693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60801, 6, 3, 1, 8, 267172, 3554, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60802, 6, 3, 2, 8, 267172, 7556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60803, 6, 3, 3, 8, 267172, 11541, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60804, 6, 3, 4, 8, 267172, 15556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60805, 6, 3, 5, 8, 267172, 19557, 0, 1, 1, 0)
GO
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60806, 6, 3, 6, 8, 267172, 23557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60807, 6, 3, 7, 8, 267145, 29094, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60808, 6, 3, 8, 8, 267118, 33112, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60809, 6, 3, 9, 8, 267091, 37086, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60810, 6, 3, 10, 8, 267064, 41132, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60811, 6, 3, 11, 8, 267037, 45143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60812, 6, 3, 12, 8, 267010, 49143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60813, 6, 3, 13, 8, 266983, 54677, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60814, 6, 3, 14, 8, 266956, 58666, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60815, 6, 3, 15, 8, 266929, 62651, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60816, 6, 3, 16, 8, 266902, 66693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60817, 6, 3, 17, 8, 266875, 70693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60818, 6, 3, 18, 8, 266848, 74693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60901, 6, 3, 1, 9, 242185, 3554, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60902, 6, 3, 2, 9, 242185, 7556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60903, 6, 3, 3, 9, 242185, 11541, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60904, 6, 3, 4, 9, 242185, 15556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60905, 6, 3, 5, 9, 242185, 19557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60906, 6, 3, 6, 9, 242185, 23557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60907, 6, 3, 7, 9, 242158, 29094, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60908, 6, 3, 8, 9, 242131, 33112, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60909, 6, 3, 9, 9, 242104, 37086, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60910, 6, 3, 10, 9, 242077, 41132, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60911, 6, 3, 11, 9, 242050, 45143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60912, 6, 3, 12, 9, 242023, 49143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60913, 6, 3, 13, 9, 241996, 54677, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60914, 6, 3, 14, 9, 241969, 58666, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60915, 6, 3, 15, 9, 241942, 62651, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60916, 6, 3, 16, 9, 241915, 66693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60917, 6, 3, 17, 9, 241888, 70693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (60918, 6, 3, 18, 9, 241861, 74693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61001, 6, 3, 1, 10, 217250, 3554, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61002, 6, 3, 2, 10, 217250, 7556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61003, 6, 3, 3, 10, 217250, 11541, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61004, 6, 3, 4, 10, 217250, 15556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61005, 6, 3, 5, 10, 217250, 19557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61006, 6, 3, 6, 10, 217250, 23557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61007, 6, 3, 7, 10, 217223, 29094, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61008, 6, 3, 8, 10, 217196, 33112, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61009, 6, 3, 9, 10, 217169, 37086, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61010, 6, 3, 10, 10, 217142, 41132, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61011, 6, 3, 11, 10, 217115, 45143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61012, 6, 3, 12, 10, 217088, 49143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61013, 6, 3, 13, 10, 217061, 54677, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61014, 6, 3, 14, 10, 217034, 58666, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61015, 6, 3, 15, 10, 217007, 62651, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61016, 6, 3, 16, 10, 216980, 66693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61017, 6, 3, 17, 10, 216953, 70693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61018, 6, 3, 18, 10, 216926, 74693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61101, 6, 3, 1, 11, 192259, 3554, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61102, 6, 3, 2, 11, 192259, 7556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61103, 6, 3, 3, 11, 192259, 11541, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61104, 6, 3, 4, 11, 192259, 15556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61105, 6, 3, 5, 11, 192259, 19557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61106, 6, 3, 6, 11, 192259, 23557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61107, 6, 3, 7, 11, 192232, 29094, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61108, 6, 3, 8, 11, 192205, 33112, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61109, 6, 3, 9, 11, 192178, 37086, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61110, 6, 3, 10, 11, 192151, 41132, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61111, 6, 3, 11, 11, 192124, 45143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61112, 6, 3, 12, 11, 192097, 49143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61113, 6, 3, 13, 11, 192070, 54677, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61114, 6, 3, 14, 11, 192043, 58666, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61115, 6, 3, 15, 11, 192016, 62651, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61116, 6, 3, 16, 11, 191989, 66693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61117, 6, 3, 17, 11, 191962, 70693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61118, 6, 3, 18, 11, 191935, 74693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61201, 6, 3, 1, 12, 167310, 3554, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61202, 6, 3, 2, 12, 167310, 7556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61203, 6, 3, 3, 12, 167310, 11541, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61204, 6, 3, 4, 12, 167310, 15556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61205, 6, 3, 5, 12, 167310, 19557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61206, 6, 3, 6, 12, 167310, 23557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61207, 6, 3, 7, 12, 167283, 29094, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61208, 6, 3, 8, 12, 167256, 33112, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61209, 6, 3, 9, 12, 167229, 37086, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61210, 6, 3, 10, 12, 167202, 41132, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61211, 6, 3, 11, 12, 167175, 45143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61212, 6, 3, 12, 12, 167148, 49143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61213, 6, 3, 13, 12, 167121, 54677, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61214, 6, 3, 14, 12, 167094, 58666, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61215, 6, 3, 15, 12, 167067, 62651, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61216, 6, 3, 16, 12, 167040, 66693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61217, 6, 3, 17, 12, 167013, 70693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61218, 6, 3, 18, 12, 166986, 74693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61301, 6, 3, 1, 13, 142374, 3554, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61302, 6, 3, 2, 13, 142374, 7556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61303, 6, 3, 3, 13, 142374, 11541, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61304, 6, 3, 4, 13, 142374, 15556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61305, 6, 3, 5, 13, 142374, 19557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61306, 6, 3, 6, 13, 142374, 23557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61307, 6, 3, 7, 13, 142347, 29094, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61308, 6, 3, 8, 13, 142320, 33112, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61309, 6, 3, 9, 13, 142293, 37086, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61310, 6, 3, 10, 13, 142266, 41132, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61311, 6, 3, 11, 13, 142239, 45143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61312, 6, 3, 12, 13, 142212, 49143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61313, 6, 3, 13, 13, 142185, 54677, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61314, 6, 3, 14, 13, 142158, 58666, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61315, 6, 3, 15, 13, 142131, 62651, 0, 1, 1, 0)
GO
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61316, 6, 3, 16, 13, 142104, 66693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61317, 6, 3, 17, 13, 142077, 70693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61318, 6, 3, 18, 13, 142050, 74693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61401, 6, 3, 1, 14, 117448, 3554, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61402, 6, 3, 2, 14, 117448, 7556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61403, 6, 3, 3, 14, 117448, 11541, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61404, 6, 3, 4, 14, 117448, 15556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61405, 6, 3, 5, 14, 117448, 19557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61406, 6, 3, 6, 14, 117448, 23557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61407, 6, 3, 7, 14, 117421, 29094, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61408, 6, 3, 8, 14, 117394, 33112, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61409, 6, 3, 9, 14, 117367, 37086, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61410, 6, 3, 10, 14, 117340, 41132, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61411, 6, 3, 11, 14, 117313, 45143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61412, 6, 3, 12, 14, 117286, 49143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61413, 6, 3, 13, 14, 117259, 54677, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61414, 6, 3, 14, 14, 117232, 58666, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61415, 6, 3, 15, 14, 117205, 62651, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61416, 6, 3, 16, 14, 117178, 66693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61417, 6, 3, 17, 14, 117151, 70693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61418, 6, 3, 18, 14, 117124, 74693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61501, 6, 3, 1, 15, 92463, 3554, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61502, 6, 3, 2, 15, 92463, 7556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61503, 6, 3, 3, 15, 92463, 11541, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61504, 6, 3, 4, 15, 92463, 15556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61505, 6, 3, 5, 15, 92463, 19557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61506, 6, 3, 6, 15, 92463, 23557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61507, 6, 3, 7, 15, 92436, 29094, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61508, 6, 3, 8, 15, 92409, 33112, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61509, 6, 3, 9, 15, 92382, 37086, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61510, 6, 3, 10, 15, 92355, 41132, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61511, 6, 3, 11, 15, 92328, 45143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61512, 6, 3, 12, 15, 92301, 49143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61513, 6, 3, 13, 15, 92274, 54677, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61514, 6, 3, 14, 15, 92247, 58666, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61515, 6, 3, 15, 15, 92220, 62651, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61516, 6, 3, 16, 15, 92193, 66693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61517, 6, 3, 17, 15, 92166, 70693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61518, 6, 3, 18, 15, 92139, 74693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61601, 6, 3, 1, 16, 67482, 3554, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61602, 6, 3, 2, 16, 67482, 7556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61603, 6, 3, 3, 16, 67482, 11541, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61604, 6, 3, 4, 16, 67482, 15556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61605, 6, 3, 5, 16, 67482, 19557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61606, 6, 3, 6, 16, 67482, 23557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61607, 6, 3, 7, 16, 67455, 29094, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61608, 6, 3, 8, 16, 67428, 33112, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61609, 6, 3, 9, 16, 67401, 37086, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61610, 6, 3, 10, 16, 67374, 41132, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61611, 6, 3, 11, 16, 67347, 45143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61612, 6, 3, 12, 16, 67320, 49143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61613, 6, 3, 13, 16, 67293, 54677, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61614, 6, 3, 14, 16, 67266, 58666, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61615, 6, 3, 15, 16, 67239, 62651, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61616, 6, 3, 16, 16, 67212, 66693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61617, 6, 3, 17, 16, 67185, 70693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61618, 6, 3, 18, 16, 67158, 74693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61701, 6, 3, 1, 17, 42591, 3554, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61702, 6, 3, 2, 17, 42591, 7556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61703, 6, 3, 3, 17, 42591, 11541, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61704, 6, 3, 4, 17, 42591, 15556, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61705, 6, 3, 5, 17, 42591, 19557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61706, 6, 3, 6, 17, 42591, 23557, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61707, 6, 3, 7, 17, 42564, 29094, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61708, 6, 3, 8, 17, 42537, 33112, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61709, 6, 3, 9, 17, 42510, 37086, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61710, 6, 3, 10, 17, 42483, 41132, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61711, 6, 3, 11, 17, 42456, 45143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61712, 6, 3, 12, 17, 42429, 49143, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61713, 6, 3, 13, 17, 42402, 54677, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61714, 6, 3, 14, 17, 42375, 58666, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61715, 6, 3, 15, 17, 42348, 62651, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61716, 6, 3, 16, 17, 42321, 66693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61717, 6, 3, 17, 17, 42294, 70693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (61718, 6, 3, 18, 17, 42267, 74693, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70101, 7, 4, 1, 1, 14360, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70102, 7, 4, 2, 1, 14360, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70103, 7, 4, 3, 1, 14360, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70104, 7, 4, 4, 1, 14360, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70105, 7, 4, 5, 1, 14360, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70106, 7, 4, 6, 1, 14255, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70107, 7, 4, 7, 1, 14255, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70108, 7, 4, 8, 1, 14255, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70109, 7, 4, 9, 1, 14255, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70110, 7, 4, 10, 1, 14255, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70111, 7, 4, 11, 1, 14206, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70112, 7, 4, 12, 1, 14106, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70113, 7, 4, 13, 1, 14106, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70114, 7, 4, 14, 1, 14056, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70115, 7, 4, 15, 1, 14006, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70116, 7, 4, 16, 1, 13956, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70201, 7, 4, 1, 2, 21730, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70202, 7, 4, 2, 2, 21730, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70203, 7, 4, 3, 2, 21730, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70204, 7, 4, 4, 2, 21730, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70205, 7, 4, 5, 2, 21730, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70206, 7, 4, 6, 2, 21663, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70207, 7, 4, 7, 2, 21663, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70208, 7, 4, 8, 2, 21663, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70209, 7, 4, 9, 2, 21663, 41826, 0, 1, 2, 0)
GO
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70210, 7, 4, 10, 2, 21663, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70211, 7, 4, 11, 2, 21507, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70212, 7, 4, 12, 2, 21407, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70213, 7, 4, 13, 2, 21407, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70214, 7, 4, 14, 2, 21357, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70215, 7, 4, 15, 2, 21307, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70216, 7, 4, 16, 2, 21307, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70301, 7, 4, 1, 3, 29064, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70302, 7, 4, 2, 3, 29064, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70303, 7, 4, 3, 3, 29064, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70304, 7, 4, 4, 3, 29064, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70305, 7, 4, 5, 3, 29064, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70306, 7, 4, 6, 3, 28931, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70307, 7, 4, 7, 3, 28931, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70308, 7, 4, 8, 3, 28931, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70309, 7, 4, 9, 3, 28931, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70310, 7, 4, 10, 3, 28931, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70311, 7, 4, 11, 3, 28937, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70312, 7, 4, 12, 3, 28937, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70313, 7, 4, 13, 3, 28937, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70314, 7, 4, 14, 3, 28887, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70315, 7, 4, 15, 3, 28837, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70316, 7, 4, 16, 3, 28837, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70401, 7, 4, 1, 4, 38829, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70402, 7, 4, 2, 4, 38829, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70403, 7, 4, 3, 4, 38829, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70404, 7, 4, 4, 4, 38829, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70405, 7, 4, 5, 4, 38829, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70406, 7, 4, 6, 4, 38724, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70407, 7, 4, 7, 4, 38724, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70408, 7, 4, 8, 4, 38724, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70409, 7, 4, 9, 4, 38724, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70410, 7, 4, 10, 4, 38724, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70411, 7, 4, 11, 4, 38678, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70412, 7, 4, 12, 4, 38578, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70413, 7, 4, 13, 4, 38578, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70414, 7, 4, 14, 4, 38528, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70415, 7, 4, 15, 4, 38478, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70416, 7, 4, 16, 4, 38578, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70501, 7, 4, 1, 5, 46190, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70502, 7, 4, 2, 5, 46190, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70503, 7, 4, 3, 5, 46190, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70504, 7, 4, 4, 5, 46190, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70505, 7, 4, 5, 5, 46190, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70506, 7, 4, 6, 5, 46109, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70507, 7, 4, 7, 5, 46109, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70508, 7, 4, 8, 5, 46109, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70509, 7, 4, 9, 5, 46109, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70510, 7, 4, 10, 5, 46109, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70511, 7, 4, 11, 5, 46057, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70512, 7, 4, 12, 5, 45957, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70513, 7, 4, 13, 5, 45957, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70514, 7, 4, 14, 5, 45907, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70515, 7, 4, 15, 5, 45857, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70516, 7, 4, 16, 5, 45857, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70601, 7, 4, 1, 6, 53580, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70602, 7, 4, 2, 6, 53580, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70603, 7, 4, 3, 6, 53580, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70604, 7, 4, 4, 6, 53580, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70605, 7, 4, 5, 6, 53580, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70606, 7, 4, 6, 6, 53394, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70607, 7, 4, 7, 6, 53394, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70608, 7, 4, 8, 6, 53394, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70609, 7, 4, 9, 6, 53394, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70610, 7, 4, 10, 6, 53394, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70611, 7, 4, 11, 6, 53335, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70612, 7, 4, 12, 6, 53235, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70613, 7, 4, 13, 6, 53235, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70614, 7, 4, 14, 6, 53185, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70615, 7, 4, 15, 6, 53135, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70616, 7, 4, 16, 6, 53135, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70701, 7, 4, 1, 7, 60825, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70702, 7, 4, 2, 7, 60825, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70703, 7, 4, 3, 7, 60825, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70704, 7, 4, 4, 7, 60825, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70705, 7, 4, 5, 7, 60825, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70706, 7, 4, 6, 7, 60762, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70707, 7, 4, 7, 7, 60762, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70708, 7, 4, 8, 7, 60762, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70709, 7, 4, 9, 7, 60762, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70710, 7, 4, 10, 7, 60762, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70711, 7, 4, 11, 7, 60683, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70712, 7, 4, 12, 7, 60583, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70713, 7, 4, 13, 7, 60583, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70714, 7, 4, 14, 7, 60533, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70715, 7, 4, 15, 7, 60483, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70716, 7, 4, 16, 7, 60483, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70801, 7, 4, 1, 8, 68231, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70802, 7, 4, 2, 8, 68231, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70803, 7, 4, 3, 8, 68231, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70804, 7, 4, 4, 8, 68231, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70805, 7, 4, 5, 8, 68231, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70806, 7, 4, 6, 8, 68150, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70807, 7, 4, 7, 8, 68150, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70808, 7, 4, 8, 8, 68150, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70809, 7, 4, 9, 8, 68150, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70810, 7, 4, 10, 8, 68150, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70811, 7, 4, 11, 8, 68001, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70812, 7, 4, 12, 8, 67901, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70813, 7, 4, 13, 8, 67901, 62075, 0, 1, 2, 0)
GO
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70814, 7, 4, 14, 8, 67851, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70815, 7, 4, 15, 8, 67801, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70816, 7, 4, 16, 8, 67901, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70901, 7, 4, 1, 9, 75571, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70902, 7, 4, 2, 9, 75571, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70903, 7, 4, 3, 9, 75571, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70904, 7, 4, 4, 9, 75571, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70905, 7, 4, 5, 9, 75571, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70906, 7, 4, 6, 9, 75492, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70907, 7, 4, 7, 9, 75492, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70908, 7, 4, 8, 9, 75492, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70909, 7, 4, 9, 9, 75492, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70910, 7, 4, 10, 9, 75492, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70911, 7, 4, 11, 9, 75434, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70912, 7, 4, 12, 9, 75234, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70913, 7, 4, 13, 9, 75234, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70914, 7, 4, 14, 9, 75184, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70915, 7, 4, 15, 9, 75134, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (70916, 7, 4, 16, 9, 75234, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71001, 7, 4, 1, 10, 82789, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71002, 7, 4, 2, 10, 82789, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71003, 7, 4, 3, 10, 82789, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71004, 7, 4, 4, 10, 82789, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71005, 7, 4, 5, 10, 82789, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71006, 7, 4, 6, 10, 82844, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71007, 7, 4, 7, 10, 82844, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71008, 7, 4, 8, 10, 82844, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71009, 7, 4, 9, 10, 82844, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71010, 7, 4, 10, 10, 82844, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71011, 7, 4, 11, 10, 82789, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71012, 7, 4, 12, 10, 82589, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71013, 7, 4, 13, 10, 82589, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71014, 7, 4, 14, 10, 82539, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71015, 7, 4, 15, 10, 82489, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71016, 7, 4, 16, 10, 82589, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71101, 7, 4, 1, 11, 90332, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71102, 7, 4, 2, 11, 90332, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71103, 7, 4, 3, 11, 90332, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71104, 7, 4, 4, 11, 90332, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71105, 7, 4, 5, 11, 90332, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71106, 7, 4, 6, 11, 90197, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71107, 7, 4, 7, 11, 90197, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71108, 7, 4, 8, 11, 90197, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71109, 7, 4, 9, 11, 90197, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71110, 7, 4, 10, 11, 90197, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71111, 7, 4, 11, 11, 90135, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71112, 7, 4, 12, 11, 89935, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71113, 7, 4, 13, 11, 89935, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71114, 7, 4, 14, 11, 89885, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71115, 7, 4, 15, 11, 89835, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71116, 7, 4, 16, 11, 89935, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71201, 7, 4, 1, 12, 97621, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71202, 7, 4, 2, 12, 97621, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71203, 7, 4, 3, 12, 97621, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71204, 7, 4, 4, 12, 97621, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71205, 7, 4, 5, 12, 97621, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71206, 7, 4, 6, 12, 97495, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71207, 7, 4, 7, 12, 97495, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71208, 7, 4, 8, 12, 97495, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71209, 7, 4, 9, 12, 97495, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71210, 7, 4, 10, 12, 97495, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71211, 7, 4, 11, 12, 97386, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71212, 7, 4, 12, 12, 97186, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71213, 7, 4, 13, 12, 97186, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71214, 7, 4, 14, 12, 97136, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71215, 7, 4, 15, 12, 97086, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71216, 7, 4, 16, 12, 97186, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71301, 7, 4, 1, 13, 104955, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71302, 7, 4, 2, 13, 104955, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71303, 7, 4, 3, 13, 104955, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71304, 7, 4, 4, 13, 104955, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71305, 7, 4, 5, 13, 104955, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71306, 7, 4, 6, 13, 104836, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71307, 7, 4, 7, 13, 104836, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71308, 7, 4, 8, 13, 104836, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71309, 7, 4, 9, 13, 104836, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71310, 7, 4, 10, 13, 104836, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71311, 7, 4, 11, 13, 104739, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71312, 7, 4, 12, 13, 104539, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71313, 7, 4, 13, 13, 104539, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71314, 7, 4, 14, 13, 104489, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71315, 7, 4, 15, 13, 104439, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71316, 7, 4, 16, 13, 104539, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71401, 7, 4, 1, 14, 112281, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71402, 7, 4, 2, 14, 112281, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71403, 7, 4, 3, 14, 112281, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71404, 7, 4, 4, 14, 112281, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71405, 7, 4, 5, 14, 112281, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71406, 7, 4, 6, 14, 112169, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71407, 7, 4, 7, 14, 112169, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71408, 7, 4, 8, 14, 112169, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71409, 7, 4, 9, 14, 112169, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71410, 7, 4, 10, 14, 112169, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71411, 7, 4, 11, 14, 112079, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71412, 7, 4, 12, 14, 111979, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71413, 7, 4, 13, 14, 111979, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71414, 7, 4, 14, 14, 111929, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71415, 7, 4, 15, 14, 111879, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71416, 7, 4, 16, 14, 111879, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71501, 7, 4, 1, 15, 119680, 3790, 0, 1, 2, 0)
GO
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71502, 7, 4, 2, 15, 119680, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71503, 7, 4, 3, 15, 119680, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71504, 7, 4, 4, 15, 119680, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71505, 7, 4, 5, 15, 119680, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71506, 7, 4, 6, 15, 119570, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71507, 7, 4, 7, 15, 119570, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71508, 7, 4, 8, 15, 119570, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71509, 7, 4, 9, 15, 119570, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71510, 7, 4, 10, 15, 119570, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71511, 7, 4, 11, 15, 119492, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71512, 7, 4, 12, 15, 119342, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71513, 7, 4, 13, 15, 119342, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71514, 7, 4, 14, 15, 119292, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71515, 7, 4, 15, 15, 119242, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71516, 7, 4, 16, 15, 119292, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71601, 7, 4, 1, 16, 127016, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71602, 7, 4, 2, 16, 127016, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71603, 7, 4, 3, 16, 127016, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71604, 7, 4, 4, 16, 127016, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71605, 7, 4, 5, 16, 127016, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71606, 7, 4, 6, 16, 126975, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71607, 7, 4, 7, 16, 126975, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71608, 7, 4, 8, 16, 126975, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71609, 7, 4, 9, 16, 126975, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71610, 7, 4, 10, 16, 126975, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71611, 7, 4, 11, 16, 126953, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71612, 7, 4, 12, 16, 126853, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71613, 7, 4, 13, 16, 126853, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71614, 7, 4, 14, 16, 126803, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71615, 7, 4, 15, 16, 126753, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71616, 7, 4, 16, 16, 126753, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71701, 7, 4, 1, 17, 134473, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71702, 7, 4, 2, 17, 134473, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71703, 7, 4, 3, 17, 134473, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71704, 7, 4, 4, 17, 134473, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71705, 7, 4, 5, 17, 134473, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71706, 7, 4, 6, 17, 134373, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71707, 7, 4, 7, 17, 134373, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71708, 7, 4, 8, 17, 134373, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71709, 7, 4, 9, 17, 134373, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71710, 7, 4, 10, 17, 134373, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71711, 7, 4, 11, 17, 134212, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71712, 7, 4, 12, 17, 134112, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71713, 7, 4, 13, 17, 134112, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71714, 7, 4, 14, 17, 134062, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71715, 7, 4, 15, 17, 134012, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71716, 7, 4, 16, 17, 134112, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71801, 7, 4, 1, 18, 141832, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71802, 7, 4, 2, 18, 141832, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71803, 7, 4, 3, 18, 141832, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71804, 7, 4, 4, 18, 141832, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71805, 7, 4, 5, 18, 141832, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71806, 7, 4, 6, 18, 141664, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71807, 7, 4, 7, 18, 141664, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71808, 7, 4, 8, 18, 141664, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71809, 7, 4, 9, 18, 141664, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71810, 7, 4, 10, 18, 141614, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71811, 7, 4, 11, 18, 141530, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71812, 7, 4, 12, 18, 141430, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71813, 7, 4, 13, 18, 141430, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71814, 7, 4, 14, 18, 141380, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71815, 7, 4, 15, 18, 141330, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71816, 7, 4, 16, 18, 141380, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71901, 7, 4, 1, 19, 149136, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71902, 7, 4, 2, 19, 149136, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71903, 7, 4, 3, 19, 149136, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71904, 7, 4, 4, 19, 149136, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71905, 7, 4, 5, 19, 149136, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71906, 7, 4, 6, 19, 149012, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71907, 7, 4, 7, 19, 149012, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71908, 7, 4, 8, 19, 149012, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71909, 7, 4, 9, 19, 149012, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71910, 7, 4, 10, 19, 149012, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71911, 7, 4, 11, 19, 148906, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71912, 7, 4, 12, 19, 148806, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71913, 7, 4, 13, 19, 148806, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71914, 7, 4, 14, 19, 148756, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71915, 7, 4, 15, 19, 148494, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (71916, 7, 4, 16, 19, 148756, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72001, 7, 4, 1, 20, 158980, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72002, 7, 4, 2, 20, 158980, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72003, 7, 4, 3, 20, 158980, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72004, 7, 4, 4, 20, 158930, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72005, 7, 4, 5, 20, 158930, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72006, 7, 4, 6, 20, 158805, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72007, 7, 4, 7, 20, 158805, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72008, 7, 4, 8, 20, 158805, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72009, 7, 4, 9, 20, 158755, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72010, 7, 4, 10, 20, 158705, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72011, 7, 4, 11, 20, 158622, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72012, 7, 4, 12, 20, 158522, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72013, 7, 4, 13, 20, 158522, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72014, 7, 4, 14, 20, 158422, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72015, 7, 4, 15, 20, 158392, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72016, 7, 4, 16, 20, 158422, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72101, 7, 4, 1, 21, 166220, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72102, 7, 4, 2, 21, 166220, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72103, 7, 4, 3, 21, 166220, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72104, 7, 4, 4, 21, 166220, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72105, 7, 4, 5, 21, 166220, 21840, 0, 1, 2, 0)
GO
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72106, 7, 4, 6, 21, 166109, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72107, 7, 4, 7, 21, 166109, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72108, 7, 4, 8, 21, 166109, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72109, 7, 4, 9, 21, 166109, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72110, 7, 4, 10, 21, 166109, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72111, 7, 4, 11, 21, 165864, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72112, 7, 4, 12, 21, 165764, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72113, 7, 4, 13, 21, 165764, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72114, 7, 4, 14, 21, 165714, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72115, 7, 4, 15, 21, 165664, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72116, 7, 4, 16, 21, 165664, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72201, 7, 4, 1, 22, 173539, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72202, 7, 4, 2, 22, 173539, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72203, 7, 4, 3, 22, 173539, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72204, 7, 4, 4, 22, 173539, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72205, 7, 4, 5, 22, 173539, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72206, 7, 4, 6, 22, 173371, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72207, 7, 4, 7, 22, 173371, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72208, 7, 4, 8, 22, 173371, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72209, 7, 4, 9, 22, 173371, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72210, 7, 4, 10, 22, 173321, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72211, 7, 4, 11, 22, 173136, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72212, 7, 4, 12, 22, 173036, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72213, 7, 4, 13, 22, 173036, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72214, 7, 4, 14, 22, 172986, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72215, 7, 4, 15, 22, 172936, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72216, 7, 4, 16, 22, 172936, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72301, 7, 4, 1, 23, 180893, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72302, 7, 4, 2, 23, 180893, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72303, 7, 4, 3, 23, 180893, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72304, 7, 4, 4, 23, 180893, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72305, 7, 4, 5, 23, 180893, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72306, 7, 4, 6, 23, 180709, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72307, 7, 4, 7, 23, 180709, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72308, 7, 4, 8, 23, 180709, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72309, 7, 4, 9, 23, 180709, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72310, 7, 4, 10, 23, 180659, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72311, 7, 4, 11, 23, 180473, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72312, 7, 4, 12, 23, 180373, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72313, 7, 4, 13, 23, 180373, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72314, 7, 4, 14, 23, 180323, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72315, 7, 4, 15, 23, 180273, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72316, 7, 4, 16, 23, 180273, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72401, 7, 4, 1, 24, 188230, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72402, 7, 4, 2, 24, 188230, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72403, 7, 4, 3, 24, 188230, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72404, 7, 4, 4, 24, 188230, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72405, 7, 4, 5, 24, 188230, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72406, 7, 4, 6, 24, 188033, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72407, 7, 4, 7, 24, 188033, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72408, 7, 4, 8, 24, 188033, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72409, 7, 4, 9, 24, 188033, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72410, 7, 4, 10, 24, 188033, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72411, 7, 4, 11, 24, 187920, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72412, 7, 4, 12, 24, 187820, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72413, 7, 4, 13, 24, 187820, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72414, 7, 4, 14, 24, 187770, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72415, 7, 4, 15, 24, 187720, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72416, 7, 4, 16, 24, 187720, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72501, 7, 4, 1, 25, 195591, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72502, 7, 4, 2, 25, 195591, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72503, 7, 4, 3, 25, 195591, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72504, 7, 4, 4, 25, 195591, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72505, 7, 4, 5, 25, 195591, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72506, 7, 4, 6, 25, 195405, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72507, 7, 4, 7, 25, 195405, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72508, 7, 4, 8, 25, 195405, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72509, 7, 4, 9, 25, 195405, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72510, 7, 4, 10, 25, 195405, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72511, 7, 4, 11, 25, 195221, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72512, 7, 4, 12, 25, 195121, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72513, 7, 4, 13, 25, 195121, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72514, 7, 4, 14, 25, 195071, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72515, 7, 4, 15, 25, 195021, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72516, 7, 4, 16, 25, 195021, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72601, 7, 4, 1, 26, 203021, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72602, 7, 4, 2, 26, 203021, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72603, 7, 4, 3, 26, 203021, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72604, 7, 4, 4, 26, 203021, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72605, 7, 4, 5, 26, 203021, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72606, 7, 4, 6, 26, 202780, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72607, 7, 4, 7, 26, 202780, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72608, 7, 4, 8, 26, 202780, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72609, 7, 4, 9, 26, 202780, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72610, 7, 4, 10, 26, 202780, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72611, 7, 4, 11, 26, 202528, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72612, 7, 4, 12, 26, 202478, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72613, 7, 4, 13, 26, 202478, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72614, 7, 4, 14, 26, 202428, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72615, 7, 4, 15, 26, 202328, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72616, 7, 4, 16, 26, 202328, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72701, 7, 4, 1, 27, 210334, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72702, 7, 4, 2, 27, 210334, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72703, 7, 4, 3, 27, 210334, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72704, 7, 4, 4, 27, 210334, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72705, 7, 4, 5, 27, 210334, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72706, 7, 4, 6, 27, 210113, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72707, 7, 4, 7, 27, 210113, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72708, 7, 4, 8, 27, 210113, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72709, 7, 4, 9, 27, 210113, 41826, 0, 1, 2, 0)
GO
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72710, 7, 4, 10, 27, 210113, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72711, 7, 4, 11, 27, 209907, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72712, 7, 4, 12, 27, 209907, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72713, 7, 4, 13, 27, 209857, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72714, 7, 4, 14, 27, 209757, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72715, 7, 4, 15, 27, 209707, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72716, 7, 4, 16, 27, 209707, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72801, 7, 4, 1, 28, 217650, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72802, 7, 4, 2, 28, 217650, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72803, 7, 4, 3, 28, 217650, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72804, 7, 4, 4, 28, 217650, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72805, 7, 4, 5, 28, 217650, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72806, 7, 4, 6, 28, 217463, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72807, 7, 4, 7, 28, 217463, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72808, 7, 4, 8, 28, 217463, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72809, 7, 4, 9, 28, 217463, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72810, 7, 4, 10, 28, 217463, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72811, 7, 4, 11, 28, 217299, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72812, 7, 4, 12, 28, 217249, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72813, 7, 4, 13, 28, 217199, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72814, 7, 4, 14, 28, 217149, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72815, 7, 4, 15, 28, 217149, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72816, 7, 4, 16, 28, 217049, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72901, 7, 4, 1, 29, 225183, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72902, 7, 4, 2, 29, 225183, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72903, 7, 4, 3, 29, 225183, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72904, 7, 4, 4, 29, 225183, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72905, 7, 4, 5, 29, 225183, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72906, 7, 4, 6, 29, 224901, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72907, 7, 4, 7, 29, 224851, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72908, 7, 4, 8, 29, 224851, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72909, 7, 4, 9, 29, 224851, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72910, 7, 4, 10, 29, 224851, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72911, 7, 4, 11, 29, 224772, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72912, 7, 4, 12, 29, 224672, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72913, 7, 4, 13, 29, 224672, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72914, 7, 4, 14, 29, 224622, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72915, 7, 4, 15, 29, 224572, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (72916, 7, 4, 16, 29, 224522, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73001, 7, 4, 1, 30, 232431, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73002, 7, 4, 2, 30, 232431, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73003, 7, 4, 3, 30, 232431, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73004, 7, 4, 4, 30, 232431, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73005, 7, 4, 5, 30, 232431, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73006, 7, 4, 6, 30, 232190, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73007, 7, 4, 7, 30, 232190, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73008, 7, 4, 8, 30, 232190, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73009, 7, 4, 9, 30, 232190, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73010, 7, 4, 10, 30, 232190, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73011, 7, 4, 11, 30, 231884, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73012, 7, 4, 12, 30, 231934, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73013, 7, 4, 13, 30, 231834, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73014, 7, 4, 14, 30, 231734, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73015, 7, 4, 15, 30, 231684, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73016, 7, 4, 16, 30, 231684, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73101, 7, 4, 1, 31, 239812, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73102, 7, 4, 2, 31, 239812, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73103, 7, 4, 3, 31, 239812, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73104, 7, 4, 4, 31, 239812, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73105, 7, 4, 5, 31, 239812, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73106, 7, 4, 6, 31, 239588, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73107, 7, 4, 7, 31, 239588, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73108, 7, 4, 8, 31, 239588, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73109, 7, 4, 9, 31, 239588, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73110, 7, 4, 10, 31, 239588, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73111, 7, 4, 11, 31, 239464, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73112, 7, 4, 12, 31, 239364, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73113, 7, 4, 13, 31, 239364, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73114, 7, 4, 14, 31, 239314, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73115, 7, 4, 15, 31, 239164, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73116, 7, 4, 16, 31, 239164, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73201, 7, 4, 1, 32, 247142, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73202, 7, 4, 2, 32, 247142, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73203, 7, 4, 3, 32, 247092, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73204, 7, 4, 4, 32, 247092, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73205, 7, 4, 5, 32, 247092, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73206, 7, 4, 6, 32, 246915, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73207, 7, 4, 7, 32, 246915, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73208, 7, 4, 8, 32, 246915, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73209, 7, 4, 9, 32, 246915, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73210, 7, 4, 10, 32, 246915, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73211, 7, 4, 11, 32, 246809, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73212, 7, 4, 12, 32, 246709, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73213, 7, 4, 13, 32, 246709, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73214, 7, 4, 14, 32, 246659, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73215, 7, 4, 15, 32, 246609, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73216, 7, 4, 16, 32, 246609, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73301, 7, 4, 1, 33, 254516, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73302, 7, 4, 2, 33, 254516, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73303, 7, 4, 3, 33, 254516, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73304, 7, 4, 4, 33, 254516, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73305, 7, 4, 5, 33, 254516, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73306, 7, 4, 6, 33, 254309, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73307, 7, 4, 7, 33, 254309, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73308, 7, 4, 8, 33, 254309, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73309, 7, 4, 9, 33, 254309, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73310, 7, 4, 10, 33, 254309, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73311, 7, 4, 11, 33, 254027, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73312, 7, 4, 12, 33, 253927, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73313, 7, 4, 13, 33, 253977, 62075, 0, 1, 2, 0)
GO
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73314, 7, 4, 14, 33, 253927, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73315, 7, 4, 15, 33, 253877, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73316, 7, 4, 16, 33, 253827, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73401, 7, 4, 1, 34, 261940, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73402, 7, 4, 2, 34, 261940, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73403, 7, 4, 3, 34, 261940, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73404, 7, 4, 4, 34, 261940, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73405, 7, 4, 5, 34, 261940, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73406, 7, 4, 6, 34, 261620, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73407, 7, 4, 7, 34, 261620, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73408, 7, 4, 8, 34, 261620, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73409, 7, 4, 9, 34, 261620, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73410, 7, 4, 10, 34, 261620, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73411, 7, 4, 11, 34, 261339, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73412, 7, 4, 12, 34, 261339, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73413, 7, 4, 13, 34, 261339, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73414, 7, 4, 14, 34, 261289, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73415, 7, 4, 15, 34, 261189, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73416, 7, 4, 16, 34, 261139, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73501, 7, 4, 1, 35, 269440, 3790, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73502, 7, 4, 2, 35, 269440, 8340, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73503, 7, 4, 3, 35, 269440, 12788, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73504, 7, 4, 4, 35, 269390, 17327, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73505, 7, 4, 5, 35, 269390, 21840, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73506, 7, 4, 6, 35, 268932, 28326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73507, 7, 4, 7, 35, 268932, 32826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73508, 7, 4, 8, 35, 268932, 37326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73509, 7, 4, 9, 35, 268932, 41826, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73510, 7, 4, 10, 35, 268932, 46326, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73511, 7, 4, 11, 35, 268728, 53075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73512, 7, 4, 12, 35, 268678, 57575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73513, 7, 4, 13, 35, 268678, 62075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73514, 7, 4, 14, 35, 268628, 66575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73515, 7, 4, 15, 35, 268528, 71075, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (73516, 7, 4, 16, 35, 268578, 75575, 0, 1, 2, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80501, 8, 4, 1, 5, 46217, 3790, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80502, 8, 4, 2, 5, 46217, 8336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80503, 8, 4, 3, 5, 46217, 12836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80504, 8, 4, 4, 5, 46217, 17336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80505, 8, 4, 5, 5, 46217, 21836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80506, 8, 4, 6, 5, 46315, 28366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80507, 8, 4, 7, 5, 46315, 32866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80508, 8, 4, 8, 5, 46315, 37366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80509, 8, 4, 9, 5, 46315, 41866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80510, 8, 4, 10, 5, 46215, 46366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80511, 8, 4, 11, 5, 46149, 53018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80512, 8, 4, 12, 5, 46149, 57518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80513, 8, 4, 13, 5, 46149, 62018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80514, 8, 4, 14, 5, 46149, 66518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80515, 8, 4, 15, 5, 46149, 71018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80516, 8, 4, 16, 5, 46149, 75518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80601, 8, 4, 1, 6, 53600, 3790, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80602, 8, 4, 2, 6, 53600, 8336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80603, 8, 4, 3, 6, 53600, 12836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80604, 8, 4, 4, 6, 53600, 17336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80605, 8, 4, 5, 6, 53600, 21836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80606, 8, 4, 6, 6, 53536, 28366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80607, 8, 4, 7, 6, 53536, 32866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80608, 8, 4, 8, 6, 53536, 37366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80609, 8, 4, 9, 6, 53536, 41866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80610, 8, 4, 10, 6, 53536, 46366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80611, 8, 4, 11, 6, 53511, 53018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80612, 8, 4, 12, 6, 53511, 57518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80613, 8, 4, 13, 6, 53511, 62018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80614, 8, 4, 14, 6, 53411, 66518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80615, 8, 4, 15, 6, 53411, 71018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80616, 8, 4, 16, 6, 53411, 75518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80701, 8, 4, 1, 7, 60962, 3790, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80702, 8, 4, 2, 7, 60962, 8336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80703, 8, 4, 3, 7, 60962, 12836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80704, 8, 4, 4, 7, 60962, 17336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80705, 8, 4, 5, 7, 60962, 21836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80706, 8, 4, 6, 7, 60893, 28366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80707, 8, 4, 7, 7, 60893, 32866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80708, 8, 4, 8, 7, 60893, 37366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80709, 8, 4, 9, 7, 60893, 41866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80710, 8, 4, 10, 7, 60893, 46366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80711, 8, 4, 11, 7, 60854, 53018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80712, 8, 4, 12, 7, 60854, 57518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80713, 8, 4, 13, 7, 60854, 62018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80714, 8, 4, 14, 7, 60854, 66518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80715, 8, 4, 15, 7, 60754, 71018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80716, 8, 4, 16, 7, 60754, 75518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80801, 8, 4, 1, 8, 68350, 3790, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80802, 8, 4, 2, 8, 68350, 8336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80803, 8, 4, 3, 8, 68350, 12836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80804, 8, 4, 4, 8, 68350, 17336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80805, 8, 4, 5, 8, 68350, 21836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80806, 8, 4, 6, 8, 68318, 28366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80807, 8, 4, 7, 8, 68318, 32866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80808, 8, 4, 8, 8, 68318, 37366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80809, 8, 4, 9, 8, 68318, 41866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80810, 8, 4, 10, 8, 68318, 46366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80811, 8, 4, 11, 8, 68262, 53018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80812, 8, 4, 12, 8, 68262, 57518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80813, 8, 4, 13, 8, 68262, 62018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80814, 8, 4, 14, 8, 68262, 66518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80815, 8, 4, 15, 8, 68162, 71018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80816, 8, 4, 16, 8, 68162, 75518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80901, 8, 4, 1, 9, 75760, 3790, 0, 1, 1, 0)
GO
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80902, 8, 4, 2, 9, 75760, 8336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80903, 8, 4, 3, 9, 75760, 12836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80904, 8, 4, 4, 9, 75760, 17336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80905, 8, 4, 5, 9, 75760, 21836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80906, 8, 4, 6, 9, 75649, 28366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80907, 8, 4, 7, 9, 75649, 32866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80908, 8, 4, 8, 9, 75649, 37366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80909, 8, 4, 9, 9, 75649, 41866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80910, 8, 4, 10, 9, 75649, 46366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80911, 8, 4, 11, 9, 75645, 53018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80912, 8, 4, 12, 9, 75645, 57518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80913, 8, 4, 13, 9, 75645, 62018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80914, 8, 4, 14, 9, 75595, 66518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80915, 8, 4, 15, 9, 75495, 71018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (80916, 8, 4, 16, 9, 75445, 75518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81001, 8, 4, 1, 10, 83116, 3790, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81002, 8, 4, 2, 10, 83116, 8336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81003, 8, 4, 3, 10, 83116, 12836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81004, 8, 4, 4, 10, 83116, 17336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81005, 8, 4, 5, 10, 83116, 21836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81006, 8, 4, 6, 10, 83018, 28366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81007, 8, 4, 7, 10, 83018, 32866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81008, 8, 4, 8, 10, 83018, 37366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81009, 8, 4, 9, 10, 83018, 41866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81010, 8, 4, 10, 10, 83018, 46366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81011, 8, 4, 11, 10, 82988, 53018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81012, 8, 4, 12, 10, 82988, 57518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81013, 8, 4, 13, 10, 82988, 62018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81014, 8, 4, 14, 10, 82888, 66518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81015, 8, 4, 15, 10, 82888, 71018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81016, 8, 4, 16, 10, 82838, 75518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81101, 8, 4, 1, 11, 90421, 3790, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81102, 8, 4, 2, 11, 90421, 8336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81103, 8, 4, 3, 11, 90421, 12836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81104, 8, 4, 4, 11, 90421, 17336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81105, 8, 4, 5, 11, 90421, 21836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81106, 8, 4, 6, 11, 90368, 28366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81107, 8, 4, 7, 11, 90368, 32866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81108, 8, 4, 8, 11, 90368, 37366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81109, 8, 4, 9, 11, 90368, 41866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81110, 8, 4, 10, 11, 90368, 46366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81111, 8, 4, 11, 11, 90336, 53018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81112, 8, 4, 12, 11, 90336, 57518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81113, 8, 4, 13, 11, 90286, 62018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81114, 8, 4, 14, 11, 90236, 66518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81115, 8, 4, 15, 11, 90236, 71018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81116, 8, 4, 16, 11, 90186, 75518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81201, 8, 4, 1, 12, 97803, 3790, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81202, 8, 4, 2, 12, 97803, 8336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81203, 8, 4, 3, 12, 97803, 12836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81204, 8, 4, 4, 12, 97803, 17336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81205, 8, 4, 5, 12, 97803, 21836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81206, 8, 4, 6, 12, 97716, 28366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81207, 8, 4, 7, 12, 97716, 32866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81208, 8, 4, 8, 12, 97716, 37366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81209, 8, 4, 9, 12, 97716, 41866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81210, 8, 4, 10, 12, 97716, 46366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81211, 8, 4, 11, 12, 97681, 53018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81212, 8, 4, 12, 12, 97681, 57518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81213, 8, 4, 13, 12, 97581, 62018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81214, 8, 4, 14, 12, 97581, 66518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81215, 8, 4, 15, 12, 97481, 71018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81216, 8, 4, 16, 12, 97481, 75518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81301, 8, 4, 1, 13, 105166, 3790, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81302, 8, 4, 2, 13, 105166, 8336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81303, 8, 4, 3, 13, 105166, 12836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81304, 8, 4, 4, 13, 105166, 17336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81305, 8, 4, 5, 13, 105166, 21836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81306, 8, 4, 6, 13, 105050, 28366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81307, 8, 4, 7, 13, 105050, 32866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81308, 8, 4, 8, 13, 105050, 37366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81309, 8, 4, 9, 13, 105050, 41866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81310, 8, 4, 10, 13, 105050, 46366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81311, 8, 4, 11, 13, 105011, 53018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81312, 8, 4, 12, 13, 105011, 57518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81313, 8, 4, 13, 13, 104961, 62018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81314, 8, 4, 14, 13, 104961, 66518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81315, 8, 4, 15, 13, 104861, 71018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81316, 8, 4, 16, 13, 104861, 75518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81401, 8, 4, 1, 14, 112484, 3790, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81402, 8, 4, 2, 14, 112484, 8336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81403, 8, 4, 3, 14, 112484, 12836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81404, 8, 4, 4, 14, 112484, 17336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81405, 8, 4, 5, 14, 112484, 21836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81406, 8, 4, 6, 14, 112417, 28366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81407, 8, 4, 7, 14, 112417, 32866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81408, 8, 4, 8, 14, 112417, 37366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81409, 8, 4, 9, 14, 112367, 41866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81410, 8, 4, 10, 14, 112367, 46366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81411, 8, 4, 11, 14, 112341, 53018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81412, 8, 4, 12, 14, 112341, 57518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81413, 8, 4, 13, 14, 112241, 62018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81414, 8, 4, 14, 14, 112241, 66518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81415, 8, 4, 15, 14, 112241, 71018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81416, 8, 4, 16, 14, 112191, 75518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81501, 8, 4, 1, 15, 119829, 3790, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81502, 8, 4, 2, 15, 119829, 8336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81503, 8, 4, 3, 15, 119829, 12836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81504, 8, 4, 4, 15, 119829, 17336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81505, 8, 4, 5, 15, 119829, 21836, 0, 1, 1, 0)
GO
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81506, 8, 4, 6, 15, 119756, 28366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81507, 8, 4, 7, 15, 119756, 32866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81508, 8, 4, 8, 15, 119756, 37366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81509, 8, 4, 9, 15, 119756, 41866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81510, 8, 4, 10, 15, 119756, 46366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81511, 8, 4, 11, 15, 119743, 53018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81512, 8, 4, 12, 15, 119693, 57518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81513, 8, 4, 13, 15, 119693, 62018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81514, 8, 4, 14, 15, 119643, 66518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81515, 8, 4, 15, 15, 119643, 71018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81516, 8, 4, 16, 15, 119593, 75518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81601, 8, 4, 1, 16, 127219, 3790, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81602, 8, 4, 2, 16, 127219, 8336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81603, 8, 4, 3, 16, 127219, 12836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81604, 8, 4, 4, 16, 127219, 17336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81605, 8, 4, 5, 16, 127219, 21836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81606, 8, 4, 6, 16, 127157, 28366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81607, 8, 4, 7, 16, 127157, 32866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81608, 8, 4, 8, 16, 127157, 37366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81609, 8, 4, 9, 16, 127157, 41866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81610, 8, 4, 10, 16, 127157, 46366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81611, 8, 4, 11, 16, 127108, 53018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81612, 8, 4, 12, 16, 127108, 57518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81613, 8, 4, 13, 16, 127108, 62018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81614, 8, 4, 14, 16, 127058, 66518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81615, 8, 4, 15, 16, 127008, 71018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81616, 8, 4, 16, 16, 127008, 75518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81701, 8, 4, 1, 17, 134554, 3790, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81702, 8, 4, 2, 17, 134554, 8336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81703, 8, 4, 3, 17, 134554, 12836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81704, 8, 4, 4, 17, 134554, 17336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81705, 8, 4, 5, 17, 134554, 21836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81706, 8, 4, 6, 17, 134537, 28366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81707, 8, 4, 7, 17, 134537, 32866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81708, 8, 4, 8, 17, 134537, 37366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81709, 8, 4, 9, 17, 134537, 41866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81710, 8, 4, 10, 17, 134537, 46366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81711, 8, 4, 11, 17, 134467, 53018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81712, 8, 4, 12, 17, 134467, 57518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81713, 8, 4, 13, 17, 134467, 62018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81714, 8, 4, 14, 17, 134417, 66518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81715, 8, 4, 15, 17, 134367, 71018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81716, 8, 4, 16, 17, 134367, 75518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81801, 8, 4, 1, 18, 141952, 3790, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81802, 8, 4, 2, 18, 141952, 8336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81803, 8, 4, 3, 18, 141952, 12836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81804, 8, 4, 4, 18, 141952, 17336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81805, 8, 4, 5, 18, 141952, 21836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81806, 8, 4, 6, 18, 141908, 28366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81807, 8, 4, 7, 18, 141908, 32866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81808, 8, 4, 8, 18, 141908, 37366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81809, 8, 4, 9, 18, 141908, 41866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81810, 8, 4, 10, 18, 141908, 46366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81811, 8, 4, 11, 18, 141860, 53018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81812, 8, 4, 12, 18, 141860, 57518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81813, 8, 4, 13, 18, 141760, 62018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81814, 8, 4, 14, 18, 141760, 66518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81815, 8, 4, 15, 18, 141710, 71018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (81816, 8, 4, 16, 18, 141710, 75518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82001, 8, 4, 1, 20, 159060, 3790, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82002, 8, 4, 2, 20, 159060, 8336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82003, 8, 4, 3, 20, 159060, 12836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82004, 8, 4, 4, 20, 159060, 17336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82005, 8, 4, 5, 20, 159060, 21836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82006, 8, 4, 6, 20, 158974, 28366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82007, 8, 4, 7, 20, 158974, 32866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82008, 8, 4, 8, 20, 158974, 37366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82009, 8, 4, 9, 20, 158974, 41866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82010, 8, 4, 10, 20, 158974, 46366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82011, 8, 4, 11, 20, 158866, 53018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82012, 8, 4, 12, 20, 158866, 57518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82013, 8, 4, 13, 20, 158866, 62018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82014, 8, 4, 14, 20, 158816, 66518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82015, 8, 4, 15, 20, 158716, 71018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82016, 8, 4, 16, 20, 158716, 75518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82101, 8, 4, 1, 21, 166458, 3790, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82102, 8, 4, 2, 21, 166458, 8336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82103, 8, 4, 3, 21, 166458, 12836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82104, 8, 4, 4, 21, 166458, 17336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82105, 8, 4, 5, 21, 166458, 21836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82106, 8, 4, 6, 21, 166339, 28366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82107, 8, 4, 7, 21, 166339, 32866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82108, 8, 4, 8, 21, 166339, 37366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82109, 8, 4, 9, 21, 166339, 41866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82110, 8, 4, 10, 21, 166289, 46366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82111, 8, 4, 11, 21, 166141, 53018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82112, 8, 4, 12, 21, 166141, 57518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82113, 8, 4, 13, 21, 166141, 62018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82114, 8, 4, 14, 21, 166091, 66518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82115, 8, 4, 15, 21, 165941, 71018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82116, 8, 4, 16, 21, 165941, 75518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82201, 8, 4, 1, 22, 173821, 3790, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82202, 8, 4, 2, 22, 173821, 8336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82203, 8, 4, 3, 22, 173821, 12836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82204, 8, 4, 4, 22, 173821, 17336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82205, 8, 4, 5, 22, 173821, 21836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82206, 8, 4, 6, 22, 173644, 28366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82207, 8, 4, 7, 22, 173644, 32866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82208, 8, 4, 8, 22, 173644, 37366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82209, 8, 4, 9, 22, 173644, 41866, 0, 1, 1, 0)
GO
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82210, 8, 4, 10, 22, 173644, 46366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82211, 8, 4, 11, 22, 173429, 53018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82212, 8, 4, 12, 22, 173429, 57518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82213, 8, 4, 13, 22, 173429, 62018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82214, 8, 4, 14, 22, 173329, 66518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82215, 8, 4, 15, 22, 173229, 71018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82216, 8, 4, 16, 22, 173229, 75518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82301, 8, 4, 1, 23, 181131, 3790, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82302, 8, 4, 2, 23, 181131, 8336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82303, 8, 4, 3, 23, 181131, 12836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82304, 8, 4, 4, 23, 181131, 17336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82305, 8, 4, 5, 23, 181131, 21836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82306, 8, 4, 6, 23, 180987, 28366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82307, 8, 4, 7, 23, 180987, 32866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82308, 8, 4, 8, 23, 180987, 37366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82309, 8, 4, 9, 23, 180987, 41866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82310, 8, 4, 10, 23, 180987, 46366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82311, 8, 4, 11, 23, 180687, 53018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82312, 8, 4, 12, 23, 180687, 57518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82313, 8, 4, 13, 23, 180687, 62018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82314, 8, 4, 14, 23, 180687, 66518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82315, 8, 4, 15, 23, 180587, 71018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82316, 8, 4, 16, 23, 180587, 75518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82401, 8, 4, 1, 24, 188548, 3790, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82402, 8, 4, 2, 24, 188548, 8336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82403, 8, 4, 3, 24, 188548, 12836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82404, 8, 4, 4, 24, 188548, 17336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82405, 8, 4, 5, 24, 188548, 21836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82406, 8, 4, 6, 24, 188381, 28366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82407, 8, 4, 7, 24, 188381, 32866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82408, 8, 4, 8, 24, 188381, 37366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82409, 8, 4, 9, 24, 188381, 41866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82410, 8, 4, 10, 24, 188381, 46366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82411, 8, 4, 11, 24, 188059, 53018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82412, 8, 4, 12, 24, 188059, 57518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82413, 8, 4, 13, 24, 188059, 62018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82414, 8, 4, 14, 24, 188059, 66518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82415, 8, 4, 15, 24, 187859, 71018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82416, 8, 4, 16, 24, 187859, 75518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82501, 8, 4, 1, 25, 195839, 3790, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82502, 8, 4, 2, 25, 195839, 8336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82503, 8, 4, 3, 25, 195839, 12836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82504, 8, 4, 4, 25, 195839, 17336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82505, 8, 4, 5, 25, 195839, 21836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82506, 8, 4, 6, 25, 195684, 28366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82507, 8, 4, 7, 25, 195684, 32866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82508, 8, 4, 8, 25, 195684, 37366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82509, 8, 4, 9, 25, 195734, 41866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82510, 8, 4, 10, 25, 195734, 46366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82511, 8, 4, 11, 25, 195487, 53018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82512, 8, 4, 12, 25, 195487, 57518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82513, 8, 4, 13, 25, 195487, 62018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82514, 8, 4, 14, 25, 195487, 66518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82515, 8, 4, 15, 25, 195387, 71018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82516, 8, 4, 16, 25, 195387, 75518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82601, 8, 4, 1, 26, 203230, 3790, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82602, 8, 4, 2, 26, 203230, 8336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82603, 8, 4, 3, 26, 203230, 12836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82604, 8, 4, 4, 26, 203230, 17336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82605, 8, 4, 5, 26, 203230, 21836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82606, 8, 4, 6, 26, 203152, 28366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82607, 8, 4, 7, 26, 203152, 32866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82608, 8, 4, 8, 26, 203102, 37366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82609, 8, 4, 9, 26, 203102, 41866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82610, 8, 4, 10, 26, 203102, 46366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82611, 8, 4, 11, 26, 202931, 53018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82612, 8, 4, 12, 26, 202931, 57518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82613, 8, 4, 13, 26, 202931, 62018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82614, 8, 4, 14, 26, 202881, 66518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82615, 8, 4, 15, 26, 202781, 71018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82616, 8, 4, 16, 26, 202731, 75518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82701, 8, 4, 1, 27, 210573, 3790, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82702, 8, 4, 2, 27, 210573, 8336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82703, 8, 4, 3, 27, 210573, 12836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82704, 8, 4, 4, 27, 210573, 17336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82705, 8, 4, 5, 27, 210573, 21836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82706, 8, 4, 6, 27, 210435, 28366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82707, 8, 4, 7, 27, 210435, 32866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82708, 8, 4, 8, 27, 210435, 37366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82709, 8, 4, 9, 27, 210435, 41866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82710, 8, 4, 10, 27, 210435, 46366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82711, 8, 4, 11, 27, 210262, 53018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82712, 8, 4, 12, 27, 210262, 57518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82713, 8, 4, 13, 27, 210262, 62018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82714, 8, 4, 14, 27, 210262, 66518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82715, 8, 4, 15, 27, 210162, 71018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82716, 8, 4, 16, 27, 210162, 75518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82801, 8, 4, 1, 28, 217947, 3790, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82802, 8, 4, 2, 28, 217947, 8336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82803, 8, 4, 3, 28, 217947, 12836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82804, 8, 4, 4, 28, 217947, 17336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82805, 8, 4, 5, 28, 217947, 21836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82806, 8, 4, 6, 28, 217831, 28366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82807, 8, 4, 7, 28, 217831, 32866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82808, 8, 4, 8, 28, 217781, 37366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82809, 8, 4, 9, 28, 217781, 41866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82810, 8, 4, 10, 28, 217781, 46366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82811, 8, 4, 11, 28, 217675, 53018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82812, 8, 4, 12, 28, 217675, 57518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82813, 8, 4, 13, 28, 217675, 62018, 0, 1, 1, 0)
GO
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82814, 8, 4, 14, 28, 217675, 66518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82815, 8, 4, 15, 28, 217575, 71018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82816, 8, 4, 16, 28, 217525, 75518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82901, 8, 4, 1, 29, 225319, 3790, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82902, 8, 4, 2, 29, 225319, 8336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82903, 8, 4, 3, 29, 225319, 12836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82904, 8, 4, 4, 29, 225319, 17336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82905, 8, 4, 5, 29, 225319, 21836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82906, 8, 4, 6, 29, 225269, 28366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82907, 8, 4, 7, 29, 225219, 32866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82908, 8, 4, 8, 29, 225219, 37366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82909, 8, 4, 9, 29, 225169, 41866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82910, 8, 4, 10, 29, 225169, 46366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82911, 8, 4, 11, 29, 225035, 53018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82912, 8, 4, 12, 29, 225035, 57518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82913, 8, 4, 13, 29, 225035, 62018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82914, 8, 4, 14, 29, 224985, 66518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82915, 8, 4, 15, 29, 224935, 71018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (82916, 8, 4, 16, 29, 224935, 75518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83001, 8, 4, 1, 30, 232662, 3790, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83002, 8, 4, 2, 30, 232662, 8336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83003, 8, 4, 3, 30, 232662, 12836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83004, 8, 4, 4, 30, 232662, 17336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83005, 8, 4, 5, 30, 232662, 21836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83006, 8, 4, 6, 30, 232569, 28366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83007, 8, 4, 7, 30, 232569, 32866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83008, 8, 4, 8, 30, 232519, 37366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83009, 8, 4, 9, 30, 232519, 41866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83010, 8, 4, 10, 30, 232519, 46366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83011, 8, 4, 11, 30, 232360, 53018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83012, 8, 4, 12, 30, 232360, 57518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83013, 8, 4, 13, 30, 232360, 62018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83014, 8, 4, 14, 30, 232360, 66518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83015, 8, 4, 15, 30, 232260, 71018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83016, 8, 4, 16, 30, 232260, 75518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83101, 8, 4, 1, 31, 240011, 3790, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83102, 8, 4, 2, 31, 240011, 8336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83103, 8, 4, 3, 31, 240011, 12836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83104, 8, 4, 4, 31, 240011, 17336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83105, 8, 4, 5, 31, 240011, 21836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83106, 8, 4, 6, 31, 239898, 28366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83107, 8, 4, 7, 31, 239848, 32866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83108, 8, 4, 8, 31, 239848, 37366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83109, 8, 4, 9, 31, 239848, 41866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83110, 8, 4, 10, 31, 239848, 46366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83111, 8, 4, 11, 31, 239693, 53018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83112, 8, 4, 12, 31, 239693, 57518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83113, 8, 4, 13, 31, 239693, 62018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83114, 8, 4, 14, 31, 239693, 66518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83115, 8, 4, 15, 31, 239593, 71018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83116, 8, 4, 16, 31, 239543, 75518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83201, 8, 4, 1, 32, 247426, 3790, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83202, 8, 4, 2, 32, 247426, 8336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83203, 8, 4, 3, 32, 247426, 12836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83204, 8, 4, 4, 32, 247426, 17336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83205, 8, 4, 5, 32, 247426, 21836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83206, 8, 4, 6, 32, 247330, 28366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83207, 8, 4, 7, 32, 247280, 32866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83208, 8, 4, 8, 32, 247230, 37366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83209, 8, 4, 9, 32, 247230, 41866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83210, 8, 4, 10, 32, 247230, 46366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83211, 8, 4, 11, 32, 247064, 53018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83212, 8, 4, 12, 32, 247064, 57518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83213, 8, 4, 13, 32, 247014, 62018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83214, 8, 4, 14, 32, 247014, 66518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83215, 8, 4, 15, 32, 246914, 71018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83216, 8, 4, 16, 32, 246914, 75518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83301, 8, 4, 1, 33, 254840, 3790, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83302, 8, 4, 2, 33, 254840, 8336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83303, 8, 4, 3, 33, 254840, 12836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83304, 8, 4, 4, 33, 254840, 17336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83305, 8, 4, 5, 33, 254840, 21836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83306, 8, 4, 6, 33, 254672, 28366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83307, 8, 4, 7, 33, 254622, 32866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83308, 8, 4, 8, 33, 254572, 37366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83309, 8, 4, 9, 33, 254572, 41866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83310, 8, 4, 10, 33, 254572, 46366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83311, 8, 4, 11, 33, 254413, 53018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83312, 8, 4, 12, 33, 254413, 57518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83313, 8, 4, 13, 33, 254413, 62018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83314, 8, 4, 14, 33, 254413, 66518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83315, 8, 4, 15, 33, 254313, 71018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83316, 8, 4, 16, 33, 254313, 75518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83401, 8, 4, 1, 34, 262160, 3790, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83402, 8, 4, 2, 34, 262160, 8336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83403, 8, 4, 3, 34, 262160, 12836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83404, 8, 4, 4, 34, 262160, 17336, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83405, 8, 4, 5, 34, 262160, 21836, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83406, 8, 4, 6, 34, 261966, 28366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83407, 8, 4, 7, 34, 261966, 32866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83408, 8, 4, 8, 34, 261916, 37366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83409, 8, 4, 9, 34, 261916, 41866, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83410, 8, 4, 10, 34, 261916, 46366, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83411, 8, 4, 11, 34, 261783, 53018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83412, 8, 4, 12, 34, 261733, 57518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83413, 8, 4, 13, 34, 261733, 62018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83414, 8, 4, 14, 34, 261733, 66518, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83415, 8, 4, 15, 34, 261633, 71018, 0, 1, 1, 0)
INSERT [dbo].[physical_Location] ([id], [ShelfId], [craneId], [Row], [Col], [X], [Y], [Z], [deep], [Direction], [signPoint]) VALUES (83416, 8, 4, 16, 34, 261633, 75518, 0, 1, 1, 0)
INSERT [dbo].[RTConfig] ([ID], [overstop], [Cranestatus], [centerDistance1], [centerDistance2]) VALUES (1, 0, 3, 6100, 6100)
INSERT [dbo].[RTConfig] ([ID], [overstop], [Cranestatus], [centerDistance1], [centerDistance2]) VALUES (2, 0, 3, 6150, 6150)
INSERT [dbo].[RTConfig] ([ID], [overstop], [Cranestatus], [centerDistance1], [centerDistance2]) VALUES (3, 0, 3, 6150, 6150)
INSERT [dbo].[RTConfig] ([ID], [overstop], [Cranestatus], [centerDistance1], [centerDistance2]) VALUES (4, 0, 3, 0, 0)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57310, 57307, 57309, N'N', 3, 57312)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57314, 57311, 57313, N'N', 3, 57316)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57318, 57315, 57317, N'N', 3, 57320)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57322, 57319, 57321, N'N', 3, 57324)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57326, 57323, 57325, N'N', 3, 57328)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57330, 57327, 57329, N'N', 3, 57332)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57334, 57331, 57333, N'N', 3, 57336)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57338, 57335, 57337, N'N', 3, 57340)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57342, 57339, 57341, N'N', 3, 57344)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57346, 57343, 57345, N'N', 3, 57348)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57350, 57347, 57349, N'N', 3, 57352)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57354, 57351, 57353, N'N', 3, 57356)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57358, 57355, 57357, N'N', 3, 57360)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57362, 57359, 57361, N'N', 3, 57364)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57366, 57363, 57365, N'N', 3, 57368)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57370, 57367, 57369, N'N', 3, 57372)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57374, 57371, 57373, N'N', 3, 57376)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57378, 57375, 57377, N'N', 3, 57380)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57382, 57379, 57381, N'N', 3, 57384)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57386, 57383, 57385, N'N', 3, 57388)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57390, 57387, 57389, N'N', 3, 57392)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57394, 57391, 57393, N'N', 3, 57396)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57398, 57395, 57397, N'N', 3, 57400)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57402, 57399, 57401, N'N', 3, 57404)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57406, 57403, 57405, N'N', 3, 57408)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57410, 57407, 57409, N'N', 3, 57412)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57414, 57411, 57413, N'N', 3, 57416)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57418, 57415, 57417, N'N', 3, 57420)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57422, 57419, 57421, N'N', 3, 57424)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57426, 57423, 57425, N'N', 3, 57428)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57430, 57427, 57429, N'N', 3, 57432)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57434, 57431, 57433, N'N', 3, 57436)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57438, 57435, 57437, N'N', 3, 57440)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57442, 57439, 57441, N'N', 3, 57444)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57446, 57443, 57445, N'N', 3, 57448)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57450, 57447, 57449, N'N', 3, 57452)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57454, 57451, 57453, N'N', 3, 57456)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57458, 57455, 57457, N'N', 3, 57460)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57462, 57459, 57461, N'N', 3, 57464)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57466, 57463, 57465, N'N', 3, 57468)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57470, 57467, 57469, N'N', 3, 57472)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57474, 57471, 57473, N'N', 3, 57476)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57478, 57475, 57477, N'N', 3, 57480)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57482, 57479, 57481, N'N', 3, 57484)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57486, 57483, 57485, N'N', 3, 57488)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57490, 57487, 57489, N'N', 3, 57492)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57494, 57491, 57493, N'N', 3, 57496)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57498, 57495, 57497, N'N', 3, 57500)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57502, 57499, 57501, N'N', 3, 57504)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57506, 57503, 57505, N'N', 3, 57508)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57510, 57507, 57509, N'N', 3, 57512)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57514, 57511, 57513, N'N', 3, 57516)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57518, 57515, 57517, N'N', 3, 57520)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57522, 57519, 57521, N'N', 3, 57524)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57526, 57523, 57525, N'N', 3, 57528)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (57530, 57527, 57529, N'N', 3, 57532)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36308, 36306, 36307, N'N', 1, 36310)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36312, 36309, 36311, N'N', 1, 36314)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36316, 36313, 36315, N'N', 1, 36318)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36320, 36317, 36319, N'N', 1, 36322)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36324, 36321, 36323, N'N', 1, 36326)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36328, 36325, 36327, N'N', 1, 36330)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36332, 36329, 36331, N'N', 1, 36334)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36336, 36333, 36335, N'N', 1, 36338)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36340, 36337, 36339, N'N', 1, 36342)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36344, 36341, 36343, N'N', 1, 36346)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36348, 36345, 36347, N'N', 1, 36350)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36352, 36349, 36351, N'N', 1, 36354)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36356, 36353, 36355, N'N', 1, 36358)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36360, 36357, 36359, N'N', 1, 36362)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36364, 36361, 36363, N'N', 1, 36366)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36368, 36365, 36367, N'N', 1, 36370)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36372, 36369, 36371, N'N', 1, 36374)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36376, 36373, 36375, N'N', 1, 36378)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36380, 36377, 36379, N'N', 1, 36382)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36384, 36381, 36383, N'N', 1, 36386)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36388, 36385, 36387, N'N', 1, 36390)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36392, 36389, 36391, N'N', 1, 36394)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36396, 36393, 36395, N'N', 1, 36398)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36400, 36397, 36399, N'N', 1, 36402)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36404, 36401, 36403, N'N', 1, 36406)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36408, 36405, 36407, N'N', 1, 36410)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36412, 36409, 36411, N'N', 1, 36414)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36416, 36413, 36415, N'N', 1, 36418)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36420, 36417, 36419, N'N', 1, 36422)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36424, 36421, 36423, N'N', 1, 36426)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36428, 36425, 36427, N'N', 1, 36430)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36432, 36429, 36431, N'N', 1, 36434)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36436, 36433, 36435, N'N', 1, 36438)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36440, 36437, 36439, N'N', 1, 36442)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36444, 36441, 36443, N'N', 1, 36446)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36448, 36445, 36447, N'N', 1, 36450)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36452, 36449, 36451, N'N', 1, 36454)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36456, 36453, 36455, N'N', 1, 36458)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36460, 36457, 36459, N'N', 1, 36462)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36464, 36461, 36463, N'N', 1, 36466)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36468, 36465, 36467, N'N', 1, 36470)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36472, 36469, 36471, N'N', 1, 36474)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36476, 36473, 36475, N'N', 1, 36478)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36480, 36477, 36479, N'N', 1, 36482)
GO
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36484, 36481, 36483, N'N', 1, 36486)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36488, 36485, 36487, N'N', 1, 36490)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36492, 36489, 36491, N'N', 1, 36494)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36496, 36493, 36495, N'N', 1, 36498)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36500, 36497, 36499, N'N', 1, 36502)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36504, 36501, 36503, N'N', 1, 36506)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36508, 36505, 36507, N'N', 1, 36510)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36512, 36509, 36511, N'N', 1, 36514)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36516, 36513, 36515, N'N', 1, 36518)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36520, 36517, 36519, N'N', 1, 36522)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36524, 36521, 36523, N'N', 1, 36526)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36528, 36525, 36527, N'N', 1, 36530)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36532, 36529, 36531, N'N', 1, 36534)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36536, 36533, 36535, N'N', 1, 36538)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36540, 36537, 36539, N'N', 1, 36542)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36544, 36541, 36543, N'N', 1, 36546)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36548, 36545, 36547, N'N', 1, 36550)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36552, 36549, 36551, N'N', 1, 36554)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36556, 36553, 36555, N'N', 1, 36558)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36560, 36557, 36559, N'N', 1, 36562)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36564, 36561, 36563, N'N', 1, 36566)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36568, 36565, 36567, N'N', 1, 36570)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36572, 36569, 36571, N'N', 1, 36574)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36576, 36573, 36575, N'N', 1, 36578)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36580, 36577, 36579, N'N', 1, 36582)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36584, 36581, 36583, N'N', 1, 36586)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36588, 36585, 36587, N'N', 1, 36590)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36592, 36589, 36591, N'N', 1, 36594)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36596, 36593, 36595, N'N', 1, 36598)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36600, 36597, 36599, N'N', 1, 36602)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36604, 36601, 36603, N'N', 1, 36606)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36608, 36605, 36607, N'N', 1, 36610)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36612, 36609, 36611, N'N', 1, 36614)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36616, 36613, 36615, N'N', 1, 36618)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36620, 36617, 36619, N'N', 1, 36622)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36624, 36621, 36623, N'N', 1, 36626)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36628, 36625, 36627, N'N', 1, 36630)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36632, 36629, 36631, N'N', 1, 36634)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36636, 36633, 36635, N'N', 1, 36638)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36640, 36637, 36639, N'N', 1, 36642)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36644, 36641, 36643, N'N', 1, 36646)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36648, 36645, 36647, N'N', 1, 36650)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36652, 36649, 36651, N'N', 1, 36654)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36656, 36653, 36655, N'N', 1, 36658)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36660, 36657, 36659, N'N', 1, 36662)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36664, 36661, 36663, N'N', 1, 36666)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36668, 36665, 36667, N'N', 1, 36670)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36672, 36669, 36671, N'N', 1, 36674)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36676, 36673, 36675, N'N', 1, 36678)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36680, 36677, 36679, N'N', 1, 36682)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36684, 36681, 36683, N'N', 1, 36686)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36688, 36685, 36687, N'N', 1, 36690)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36692, 36689, 36691, N'N', 1, 36694)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36696, 36693, 36695, N'N', 1, 36698)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36700, 36697, 36699, N'N', 1, 36702)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36704, 36701, 36703, N'N', 1, 36706)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36708, 36705, 36707, N'N', 1, 36710)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36712, 36709, 36711, N'N', 1, 36714)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36716, 36713, 36715, N'N', 1, 36718)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36720, 36717, 36719, N'N', 1, 36722)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36724, 36721, 36723, N'N', 1, 36726)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36728, 36725, 36727, N'N', 1, 36730)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36732, 36729, 36731, N'N', 1, 36734)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36736, 36733, 36735, N'N', 1, 36738)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36740, 36737, 36739, N'N', 1, 36742)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36744, 36741, 36743, N'N', 1, 36746)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36748, 36745, 36747, N'N', 1, 36750)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36752, 36749, 36751, N'N', 1, 36754)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36756, 36753, 36755, N'N', 1, 36758)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36760, 36757, 36759, N'N', 1, 36762)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36764, 36761, 36763, N'N', 1, 36766)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36768, 36765, 36767, N'N', 1, 36770)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36772, 36769, 36771, N'N', 1, 36774)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36776, 36773, 36775, N'N', 1, 36778)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36780, 36777, 36779, N'N', 1, 36782)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36784, 36781, 36783, N'N', 1, 36786)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36788, 36785, 36787, N'N', 1, 36790)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36792, 36789, 36791, N'N', 1, 36794)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36796, 36793, 36795, N'N', 1, 36798)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36800, 36797, 36799, N'N', 1, 36802)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36804, 36801, 36803, N'N', 1, 36806)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36808, 36805, 36807, N'N', 1, 36810)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36812, 36809, 36811, N'N', 1, 36814)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36816, 36813, 36815, N'N', 1, 36818)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36820, 36817, 36819, N'N', 1, 36822)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36824, 36821, 36823, N'N', 1, 36826)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36828, 36825, 36827, N'N', 1, 36830)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36832, 36829, 36831, N'N', 1, 36834)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36836, 36833, 36835, N'N', 1, 36838)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36840, 36837, 36839, N'N', 1, 36842)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36844, 36841, 36843, N'N', 1, 36846)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36848, 36845, 36847, N'N', 1, 36850)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36852, 36849, 36851, N'N', 1, 36854)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36856, 36853, 36855, N'N', 1, 36858)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36860, 36857, 36859, N'N', 1, 36862)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36864, 36861, 36863, N'N', 1, 36866)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36868, 36865, 36867, N'N', 1, 36870)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36872, 36869, 36871, N'N', 1, 36874)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36876, 36873, 36875, N'N', 1, 36878)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36880, 36877, 36879, N'N', 1, 36882)
GO
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36884, 36881, 36883, N'N', 1, 36886)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36888, 36885, 36887, N'N', 1, 36890)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36892, 36889, 36891, N'N', 1, 36894)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36896, 36893, 36895, N'N', 1, 36898)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36900, 36897, 36899, N'N', 1, 36902)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36904, 36901, 36903, N'N', 1, 36906)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36908, 36905, 36907, N'N', 1, 36910)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36912, 36909, 36911, N'N', 1, 36914)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36916, 36913, 36915, N'N', 1, 36918)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36920, 36917, 36919, N'N', 1, 36922)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36924, 36921, 36923, N'N', 1, 36926)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36928, 36925, 36927, N'N', 1, 36930)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36932, 36929, 36931, N'N', 1, 36934)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36936, 36933, 36935, N'N', 1, 36938)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36940, 36937, 36939, N'N', 1, 36942)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36944, 36941, 36943, N'N', 1, 36946)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36948, 36945, 36947, N'N', 1, 36950)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33870, 33868, 33869, N'N', 1, 33872)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33874, 33871, 33873, N'N', 1, 33876)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33878, 33875, 33877, N'N', 1, 33880)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33882, 33879, 33881, N'N', 1, 33884)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33886, 33883, 33885, N'N', 1, 33888)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33890, 33887, 33889, N'N', 1, 33892)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33894, 33891, 33893, N'N', 1, 33896)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33898, 33895, 33897, N'N', 1, 33900)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33902, 33899, 33901, N'N', 1, 33904)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33906, 33903, 33905, N'N', 1, 33908)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33910, 33907, 33909, N'N', 1, 33912)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33914, 33911, 33913, N'N', 1, 33916)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33918, 33915, 33917, N'N', 1, 33920)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33922, 33919, 33921, N'N', 1, 33924)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33926, 33923, 33925, N'N', 1, 33928)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33930, 33927, 33929, N'N', 1, 33932)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33934, 33931, 33933, N'N', 1, 33936)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33938, 33935, 33937, N'N', 1, 33940)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33942, 33939, 33941, N'N', 1, 33944)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33946, 33943, 33945, N'N', 1, 33948)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33950, 33947, 33949, N'N', 1, 33952)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33954, 33951, 33953, N'N', 1, 33956)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33958, 33955, 33957, N'N', 1, 33960)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33962, 33959, 33961, N'N', 1, 33964)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33966, 33963, 33965, N'N', 1, 33968)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33970, 33967, 33969, N'N', 1, 33972)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33974, 33971, 33973, N'N', 1, 33976)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33978, 33975, 33977, N'N', 1, 33980)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33982, 33979, 33981, N'N', 1, 33984)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33986, 33983, 33985, N'N', 1, 33988)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33990, 33987, 33989, N'N', 1, 33992)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33994, 33991, 33993, N'N', 1, 33996)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (33998, 33995, 33997, N'N', 1, 34000)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34002, 33999, 34001, N'N', 1, 34004)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34006, 34003, 34005, N'N', 1, 34008)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34010, 34007, 34009, N'N', 1, 34012)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34014, 34011, 34013, N'N', 1, 34016)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34018, 34015, 34017, N'N', 1, 34020)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34022, 34019, 34021, N'N', 1, 34024)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34026, 34023, 34025, N'N', 1, 34028)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34030, 34027, 34029, N'N', 1, 34032)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34034, 34031, 34033, N'N', 1, 34036)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34038, 34035, 34037, N'N', 1, 34040)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34042, 34039, 34041, N'N', 1, 34044)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34046, 34043, 34045, N'N', 1, 34048)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34050, 34047, 34049, N'N', 1, 34052)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34054, 34051, 34053, N'N', 1, 34056)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34058, 34055, 34057, N'N', 1, 34060)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34062, 34059, 34061, N'N', 1, 34064)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34066, 34063, 34065, N'N', 1, 34068)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34070, 34067, 34069, N'N', 1, 34072)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34074, 34071, 34073, N'N', 1, 34076)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34078, 34075, 34077, N'N', 1, 34080)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34082, 34079, 34081, N'N', 1, 34084)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34086, 34083, 34085, N'N', 1, 34088)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34090, 34087, 34089, N'N', 1, 34092)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34094, 34091, 34093, N'N', 1, 34096)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34098, 34095, 34097, N'N', 1, 34100)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34102, 34099, 34101, N'N', 1, 34104)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34106, 34103, 34105, N'N', 1, 34108)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34110, 34107, 34109, N'N', 1, 34112)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34114, 34111, 34113, N'N', 1, 34116)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34118, 34115, 34117, N'N', 1, 34120)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34122, 34119, 34121, N'N', 1, 34124)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34126, 34123, 34125, N'N', 1, 34128)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34130, 34127, 34129, N'N', 1, 34132)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34134, 34131, 34133, N'N', 1, 34136)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34138, 34135, 34137, N'N', 1, 34140)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34142, 34139, 34141, N'N', 1, 34144)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34146, 34143, 34145, N'N', 1, 34148)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34150, 34147, 34149, N'N', 1, 34152)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34154, 34151, 34153, N'N', 1, 34156)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34158, 34155, 34157, N'N', 1, 34160)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34162, 34159, 34161, N'N', 1, 34164)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34166, 34163, 34165, N'N', 1, 34168)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34170, 34167, 34169, N'N', 1, 34172)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34174, 34171, 34173, N'N', 1, 34176)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34178, 34175, 34177, N'N', 1, 34180)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34182, 34179, 34181, N'N', 1, 34184)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34186, 34183, 34185, N'N', 1, 34188)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34190, 34187, 34189, N'N', 1, 34192)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34194, 34191, 34193, N'N', 1, 34196)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34198, 34195, 34197, N'N', 1, 34200)
GO
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34202, 34199, 34201, N'N', 1, 34204)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34206, 34203, 34205, N'N', 1, 34208)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34210, 34207, 34209, N'N', 1, 34212)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34214, 34211, 34213, N'N', 1, 34216)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34218, 34215, 34217, N'N', 1, 34220)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34222, 34219, 34221, N'N', 1, 34224)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34226, 34223, 34225, N'N', 1, 34228)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34230, 34227, 34229, N'N', 1, 34232)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34234, 34231, 34233, N'N', 1, 34236)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34238, 34235, 34237, N'N', 1, 34240)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34242, 34239, 34241, N'N', 1, 34244)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34246, 34243, 34245, N'N', 1, 34248)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34250, 34247, 34249, N'N', 1, 34252)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34254, 34251, 34253, N'N', 1, 34256)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34258, 34255, 34257, N'N', 1, 34260)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34262, 34259, 34261, N'N', 1, 34264)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34266, 34263, 34265, N'N', 1, 34268)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34270, 34267, 34269, N'N', 1, 34272)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34274, 34271, 34273, N'N', 1, 34276)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34278, 34275, 34277, N'N', 1, 34280)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34282, 34279, 34281, N'N', 1, 34284)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34286, 34283, 34285, N'N', 1, 34288)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34290, 34287, 34289, N'N', 1, 34292)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34294, 34291, 34293, N'N', 1, 34296)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34298, 34295, 34297, N'N', 1, 34300)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34302, 34299, 34301, N'N', 1, 34304)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34306, 34303, 34305, N'N', 1, 34308)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34310, 34307, 34309, N'N', 1, 34312)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34314, 34311, 34313, N'N', 1, 34316)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34318, 34315, 34317, N'N', 1, 34320)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34322, 34319, 34321, N'N', 1, 34324)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34326, 34323, 34325, N'N', 1, 34328)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34330, 34327, 34329, N'N', 1, 34332)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34334, 34331, 34333, N'N', 1, 34336)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34338, 34335, 34337, N'N', 1, 34340)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34342, 34339, 34341, N'N', 1, 34344)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34346, 34343, 34345, N'N', 1, 34348)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34350, 34347, 34349, N'N', 1, 34352)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34354, 34351, 34353, N'N', 1, 34356)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34358, 34355, 34357, N'N', 1, 34360)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34362, 34359, 34361, N'N', 1, 34364)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34366, 34363, 34365, N'N', 1, 34368)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34370, 34367, 34369, N'N', 1, 34372)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34374, 34371, 34373, N'N', 1, 34376)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34378, 34375, 34377, N'N', 1, 34380)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34382, 34379, 34381, N'N', 1, 34384)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34386, 34383, 34385, N'N', 1, 34388)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34390, 34387, 34389, N'N', 1, 34392)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34394, 34391, 34393, N'N', 1, 34396)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34398, 34395, 34397, N'N', 1, 34400)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34402, 34399, 34401, N'N', 1, 34404)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34406, 34403, 34405, N'N', 1, 34408)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34410, 34407, 34409, N'N', 1, 34412)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34414, 34411, 34413, N'N', 1, 34416)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34418, 34415, 34417, N'N', 1, 34420)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34422, 34419, 34421, N'N', 1, 34424)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34426, 34423, 34425, N'N', 1, 34428)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34430, 34427, 34429, N'N', 1, 34432)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34434, 34431, 34433, N'N', 1, 34436)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34438, 34435, 34437, N'N', 1, 34440)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34442, 34439, 34441, N'N', 1, 34444)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34446, 34443, 34445, N'N', 1, 34448)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34450, 34447, 34449, N'N', 1, 34452)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34454, 34451, 34453, N'N', 1, 34456)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34458, 34455, 34457, N'N', 1, 34460)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34462, 34459, 34461, N'N', 1, 34464)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34466, 34463, 34465, N'N', 1, 34468)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34470, 34467, 34469, N'N', 1, 34472)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34474, 34471, 34473, N'N', 1, 34476)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34478, 34475, 34477, N'N', 1, 34480)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34482, 34479, 34481, N'N', 1, 34484)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34486, 34483, 34485, N'N', 1, 34488)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34490, 34487, 34489, N'N', 1, 34492)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34494, 34491, 34493, N'N', 1, 34496)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34498, 34495, 34497, N'N', 1, 34500)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34502, 34499, 34501, N'N', 1, 34504)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34506, 34503, 34505, N'N', 1, 34508)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34510, 34507, 34509, N'N', 1, 34512)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34514, 34511, 34513, N'N', 1, 34516)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34518, 34515, 34517, N'N', 1, 34520)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34522, 34519, 34521, N'N', 1, 34524)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34526, 34523, 34525, N'N', 1, 34528)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34530, 34527, 34529, N'N', 1, 34532)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34534, 34531, 34533, N'N', 1, 34536)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34538, 34535, 34537, N'N', 1, 34540)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34542, 34539, 34541, N'N', 1, 34544)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34546, 34543, 34545, N'N', 1, 34548)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34550, 34547, 34549, N'N', 1, 34552)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34554, 34551, 34553, N'N', 1, 34556)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34558, 34555, 34557, N'N', 1, 34560)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34562, 34559, 34561, N'N', 1, 34564)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34566, 34563, 34565, N'N', 1, 34568)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34570, 34567, 34569, N'N', 1, 34572)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34574, 34571, 34573, N'N', 1, 34576)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34578, 34575, 34577, N'N', 1, 34580)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34582, 34579, 34581, N'N', 1, 34584)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34586, 34583, 34585, N'N', 1, 34588)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34590, 34587, 34589, N'N', 1, 34592)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34594, 34591, 34593, N'N', 1, 34596)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34598, 34595, 34597, N'N', 1, 34600)
GO
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34602, 34599, 34601, N'N', 1, 34604)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34606, 34603, 34605, N'N', 1, 34608)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34610, 34607, 34609, N'N', 1, 34612)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34614, 34611, 34613, N'N', 1, 34616)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34618, 34615, 34617, N'N', 1, 34620)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34622, 34619, 34621, N'N', 1, 34624)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34626, 34623, 34625, N'N', 1, 34628)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34630, 34627, 34629, N'N', 1, 34632)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34634, 34631, 34633, N'N', 1, 34636)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34638, 34635, 34637, N'N', 1, 34640)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34642, 34639, 34641, N'N', 1, 34644)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34646, 34643, 34645, N'N', 1, 34648)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34650, 34647, 34649, N'N', 1, 34652)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34654, 34651, 34653, N'N', 1, 34656)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34658, 34655, 34657, N'N', 1, 34660)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34662, 34659, 34661, N'N', 1, 34664)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34666, 34663, 34665, N'N', 1, 34668)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34670, 34667, 34669, N'N', 1, 34672)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34674, 34671, 34673, N'N', 1, 34676)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34678, 34675, 34677, N'N', 1, 34680)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34682, 34679, 34681, N'N', 1, 34684)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34686, 34683, 34685, N'N', 1, 34688)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34690, 34687, 34689, N'N', 1, 34692)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34694, 34691, 34693, N'N', 1, 34696)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34698, 34695, 34697, N'N', 1, 34700)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34702, 34699, 34701, N'N', 1, 34704)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34706, 34703, 34705, N'N', 1, 34708)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34710, 34707, 34709, N'N', 1, 34712)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34714, 34711, 34713, N'N', 1, 34716)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34718, 34715, 34717, N'N', 1, 34720)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34722, 34719, 34721, N'N', 1, 34724)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34726, 34723, 34725, N'N', 1, 34728)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34730, 34727, 34729, N'N', 1, 34732)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34734, 34731, 34733, N'N', 1, 34736)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34738, 34735, 34737, N'N', 1, 34740)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34742, 34739, 34741, N'N', 1, 34744)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34746, 34743, 34745, N'N', 1, 34748)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34750, 34747, 34749, N'N', 1, 34752)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34754, 34751, 34753, N'N', 1, 34756)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34758, 34755, 34757, N'N', 1, 34760)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34762, 34759, 34761, N'N', 1, 34764)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34766, 34763, 34765, N'N', 1, 34768)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34770, 34767, 34769, N'N', 1, 34772)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34774, 34771, 34773, N'N', 1, 34776)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34778, 34775, 34777, N'N', 1, 34780)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34782, 34779, 34781, N'N', 1, 34784)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34786, 34783, 34785, N'N', 1, 34788)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34790, 34787, 34789, N'N', 1, 34792)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34794, 34791, 34793, N'N', 1, 34796)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34798, 34795, 34797, N'N', 1, 34800)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34802, 34799, 34801, N'N', 1, 34804)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34806, 34803, 34805, N'N', 1, 34808)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34810, 34807, 34809, N'N', 1, 34812)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34814, 34811, 34813, N'N', 1, 34816)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34818, 34815, 34817, N'N', 1, 34820)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34822, 34819, 34821, N'N', 1, 34824)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34826, 34823, 34825, N'N', 1, 34828)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34830, 34827, 34829, N'N', 1, 34832)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34834, 34831, 34833, N'N', 1, 34836)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34838, 34835, 34837, N'N', 1, 34840)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34842, 34839, 34841, N'N', 1, 34844)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34846, 34843, 34845, N'N', 1, 34848)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34850, 34847, 34849, N'N', 1, 34852)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34854, 34851, 34853, N'N', 1, 34856)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34858, 34855, 34857, N'N', 1, 34860)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34862, 34859, 34861, N'N', 1, 34864)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34866, 34863, 34865, N'N', 1, 34868)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34870, 34867, 34869, N'N', 1, 34872)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34874, 34871, 34873, N'N', 1, 34876)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34878, 34875, 34877, N'N', 1, 34880)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34882, 34879, 34881, N'N', 1, 34884)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34886, 34883, 34885, N'N', 1, 34888)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34890, 34887, 34889, N'N', 1, 34892)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34894, 34891, 34893, N'N', 1, 34896)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34898, 34895, 34897, N'N', 1, 34900)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34902, 34899, 34901, N'N', 1, 34904)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34906, 34903, 34905, N'N', 1, 34908)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34910, 34907, 34909, N'N', 1, 34912)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34914, 34911, 34913, N'N', 1, 34916)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34918, 34915, 34917, N'N', 1, 34920)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34922, 34919, 34921, N'N', 1, 34924)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34926, 34923, 34925, N'N', 1, 34928)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34930, 34927, 34929, N'N', 1, 34932)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34934, 34931, 34933, N'N', 1, 34936)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34938, 34935, 34937, N'N', 1, 34940)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34942, 34939, 34941, N'N', 1, 34944)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34946, 34943, 34945, N'N', 1, 34948)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34950, 34947, 34949, N'N', 1, 34952)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34954, 34951, 34953, N'N', 1, 34956)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34958, 34955, 34957, N'N', 1, 34960)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34962, 34959, 34961, N'N', 1, 34964)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34966, 34963, 34965, N'N', 1, 34968)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34970, 34967, 34969, N'N', 1, 34972)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34974, 34971, 34973, N'N', 1, 34976)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34978, 34975, 34977, N'N', 1, 34980)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34982, 34979, 34981, N'N', 1, 34984)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34986, 34983, 34985, N'N', 1, 34988)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34990, 34987, 34989, N'N', 1, 34992)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34994, 34991, 34993, N'N', 1, 34996)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (34998, 34995, 34997, N'N', 1, 35000)
GO
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35002, 34999, 35001, N'N', 1, 35004)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35006, 35003, 35005, N'N', 1, 35008)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35010, 35007, 35009, N'N', 1, 35012)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35014, 35011, 35013, N'N', 1, 35016)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35018, 35015, 35017, N'N', 1, 35020)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35022, 35019, 35021, N'N', 1, 35024)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35026, 35023, 35025, N'N', 1, 35028)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35030, 35027, 35029, N'N', 1, 35032)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35034, 35031, 35033, N'N', 1, 35036)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35038, 35035, 35037, N'N', 1, 35040)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35042, 35039, 35041, N'N', 1, 35044)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35046, 35043, 35045, N'N', 1, 35048)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35050, 35047, 35049, N'N', 1, 35052)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35054, 35051, 35053, N'N', 1, 35056)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35058, 35055, 35057, N'N', 1, 35060)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35062, 35059, 35061, N'N', 1, 35064)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35066, 35063, 35065, N'N', 1, 35068)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35070, 35067, 35069, N'N', 1, 35072)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35074, 35071, 35073, N'N', 1, 35076)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35078, 35075, 35077, N'N', 1, 35080)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35082, 35079, 35081, N'N', 1, 35084)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35089, 35087, 35088, N'N', 1, 35091)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35093, 35090, 35092, N'N', 1, 35095)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35097, 35094, 35096, N'N', 1, 35099)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35101, 35098, 35100, N'N', 1, 35103)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35105, 35102, 35104, N'N', 1, 35107)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35109, 35106, 35108, N'N', 1, 35111)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35113, 35110, 35112, N'N', 1, 35115)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35117, 35114, 35116, N'N', 1, 35119)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35121, 35118, 35120, N'N', 1, 35123)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35125, 35122, 35124, N'N', 1, 35127)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35129, 35126, 35128, N'N', 1, 35131)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35133, 35130, 35132, N'N', 1, 35135)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35137, 35134, 35136, N'N', 1, 35139)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35141, 35138, 35140, N'N', 1, 35143)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35145, 35142, 35144, N'N', 1, 35147)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35149, 35146, 35148, N'N', 1, 35151)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35153, 35150, 35152, N'N', 1, 35155)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35157, 35154, 35156, N'N', 1, 35159)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55323, 55320, 55322, N'N', 3, 55325)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55327, 55324, 55326, N'N', 3, 55329)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55331, 55328, 55330, N'N', 3, 55333)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55335, 55332, 55334, N'N', 3, 55337)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55339, 55336, 55338, N'N', 3, 55341)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55343, 55340, 55342, N'N', 3, 55345)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55347, 55344, 55346, N'N', 3, 55349)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55351, 55348, 55350, N'N', 3, 55353)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55355, 55352, 55354, N'N', 3, 55357)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55359, 55356, 55358, N'N', 3, 55361)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55363, 55360, 55362, N'N', 3, 55365)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55367, 55364, 55366, N'N', 3, 55369)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55371, 55368, 55370, N'N', 3, 55373)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55375, 55372, 55374, N'N', 3, 55377)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55379, 55376, 55378, N'N', 3, 55381)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55383, 55380, 55382, N'N', 3, 55385)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55387, 55384, 55386, N'N', 3, 55389)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55391, 55388, 55390, N'N', 3, 55393)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55395, 55392, 55394, N'N', 3, 55397)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55399, 55396, 55398, N'N', 3, 55401)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55403, 55400, 55402, N'N', 3, 55405)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55407, 55404, 55406, N'N', 3, 55409)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55411, 55408, 55410, N'N', 3, 55413)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55415, 55412, 55414, N'N', 3, 55417)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55419, 55416, 55418, N'N', 3, 55421)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55423, 55420, 55422, N'N', 3, 55425)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55427, 55424, 55426, N'N', 3, 55429)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55431, 55428, 55430, N'N', 3, 55433)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55435, 55432, 55434, N'N', 3, 55437)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55439, 55436, 55438, N'N', 3, 55441)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55443, 55440, 55442, N'N', 3, 55445)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55447, 55444, 55446, N'N', 3, 55449)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55451, 55448, 55450, N'N', 3, 55453)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55455, 55452, 55454, N'N', 3, 55457)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55459, 55456, 55458, N'N', 3, 55461)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55463, 55460, 55462, N'N', 3, 55465)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55467, 55464, 55466, N'N', 3, 55469)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55471, 55468, 55470, N'N', 3, 55473)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55475, 55472, 55474, N'N', 3, 55477)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55479, 55476, 55478, N'N', 3, 55481)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55483, 55480, 55482, N'N', 3, 55485)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55487, 55484, 55486, N'N', 3, 55489)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55491, 55488, 55490, N'N', 3, 55493)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55495, 55492, 55494, N'N', 3, 55497)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55499, 55496, 55498, N'N', 3, 55501)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55503, 55500, 55502, N'N', 3, 55505)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55507, 55504, 55506, N'N', 3, 55509)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55511, 55508, 55510, N'N', 3, 55513)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55515, 55512, 55514, N'N', 3, 55517)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55519, 55516, 55518, N'N', 3, 55521)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55523, 55520, 55522, N'N', 3, 55525)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55527, 55524, 55526, N'N', 3, 55529)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55531, 55528, 55530, N'N', 3, 55533)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55535, 55532, 55534, N'N', 3, 55537)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55539, 55536, 55538, N'N', 3, 55541)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55543, 55540, 55542, N'N', 3, 55545)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55547, 55544, 55546, N'N', 3, 55549)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55551, 55548, 55550, N'N', 3, 55553)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55555, 55552, 55554, N'N', 3, 55557)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55559, 55556, 55558, N'N', 3, 55561)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55563, 55560, 55562, N'N', 3, 55565)
GO
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55567, 55564, 55566, N'N', 3, 55569)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55571, 55568, 55570, N'N', 3, 55573)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55575, 55572, 55574, N'N', 3, 55577)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55579, 55576, 55578, N'N', 3, 55581)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55583, 55580, 55582, N'N', 3, 55585)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55587, 55584, 55586, N'N', 3, 55589)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55591, 55588, 55590, N'N', 3, 55593)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55595, 55592, 55594, N'N', 3, 55597)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55599, 55596, 55598, N'N', 3, 55601)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55603, 55600, 55602, N'N', 3, 55605)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55607, 55604, 55606, N'N', 3, 55609)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55611, 55608, 55610, N'N', 3, 55613)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55615, 55612, 55614, N'N', 3, 55617)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55619, 55616, 55618, N'N', 3, 55621)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55623, 55620, 55622, N'N', 3, 55625)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55627, 55624, 55626, N'N', 3, 55629)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55631, 55628, 55630, N'N', 3, 55633)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55635, 55632, 55634, N'N', 3, 55637)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55639, 55636, 55638, N'N', 3, 55641)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55643, 55640, 55642, N'N', 3, 55645)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55647, 55644, 55646, N'N', 3, 55649)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55651, 55648, 55650, N'N', 3, 55653)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55655, 55652, 55654, N'N', 3, 55657)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55659, 55656, 55658, N'N', 3, 55661)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55663, 55660, 55662, N'N', 3, 55665)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55667, 55664, 55666, N'N', 3, 55669)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55671, 55668, 55670, N'N', 3, 55673)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55675, 55672, 55674, N'N', 3, 55677)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55679, 55676, 55678, N'N', 3, 55681)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55683, 55680, 55682, N'N', 3, 55685)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55687, 55684, 55686, N'N', 3, 55689)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55691, 55688, 55690, N'N', 3, 55693)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55695, 55692, 55694, N'N', 3, 55697)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55699, 55696, 55698, N'N', 3, 55701)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35161, 35158, 35160, N'N', 1, 35163)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35165, 35162, 35164, N'N', 1, 35167)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35169, 35166, 35168, N'N', 1, 35171)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35173, 35170, 35172, N'N', 1, 35175)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35177, 35174, 35176, N'N', 1, 35179)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35181, 35178, 35180, N'N', 1, 35183)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35185, 35182, 35184, N'N', 1, 35187)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35189, 35186, 35188, N'N', 1, 35191)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35193, 35190, 35192, N'N', 1, 35195)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35197, 35194, 35196, N'N', 1, 35199)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35201, 35198, 35200, N'N', 1, 35203)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35205, 35202, 35204, N'N', 1, 35207)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35209, 35206, 35208, N'N', 1, 35211)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35213, 35210, 35212, N'N', 1, 35215)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35217, 35214, 35216, N'N', 1, 35219)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35221, 35218, 35220, N'N', 1, 35223)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35225, 35222, 35224, N'N', 1, 35227)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35229, 35226, 35228, N'N', 1, 35231)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35233, 35230, 35232, N'N', 1, 35235)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35237, 35234, 35236, N'N', 1, 35239)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35241, 35238, 35240, N'N', 1, 35243)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35245, 35242, 35244, N'N', 1, 35247)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35249, 35246, 35248, N'N', 1, 35251)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35253, 35250, 35252, N'N', 1, 35255)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35257, 35254, 35256, N'N', 1, 35259)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35261, 35258, 35260, N'N', 1, 35263)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35265, 35262, 35264, N'N', 1, 35267)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35269, 35266, 35268, N'N', 1, 35271)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35273, 35270, 35272, N'N', 1, 35275)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35277, 35274, 35276, N'N', 1, 35279)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35281, 35278, 35280, N'N', 1, 35283)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35285, 35282, 35284, N'N', 1, 35287)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35289, 35286, 35288, N'N', 1, 35291)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35293, 35290, 35292, N'N', 1, 35295)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35297, 35294, 35296, N'N', 1, 35299)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35301, 35298, 35300, N'N', 1, 35303)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35305, 35302, 35304, N'N', 1, 35307)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35309, 35306, 35308, N'N', 1, 35311)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35313, 35310, 35312, N'N', 1, 35315)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35317, 35314, 35316, N'N', 1, 35319)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35321, 35318, 35320, N'N', 1, 35323)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35325, 35322, 35324, N'N', 1, 35327)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35329, 35326, 35328, N'N', 1, 35331)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35333, 35330, 35332, N'N', 1, 35335)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35337, 35334, 35336, N'N', 1, 35339)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35341, 35338, 35340, N'N', 1, 35343)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35345, 35342, 35344, N'N', 1, 35347)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35349, 35346, 35348, N'N', 1, 35351)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35353, 35350, 35352, N'N', 1, 35355)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35357, 35354, 35356, N'N', 1, 35359)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35361, 35358, 35360, N'N', 1, 35363)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35365, 35362, 35364, N'N', 1, 35367)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35369, 35366, 35368, N'N', 1, 35371)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35373, 35370, 35372, N'N', 1, 35375)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35377, 35374, 35376, N'N', 1, 35379)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35381, 35378, 35380, N'N', 1, 35383)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35385, 35382, 35384, N'N', 1, 35387)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35389, 35386, 35388, N'N', 1, 35391)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35393, 35390, 35392, N'N', 1, 35395)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35397, 35394, 35396, N'N', 1, 35399)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35401, 35398, 35400, N'N', 1, 35403)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35405, 35402, 35404, N'N', 1, 35407)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35409, 35406, 35408, N'N', 1, 35411)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35413, 35410, 35412, N'N', 1, 35415)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35417, 35414, 35416, N'N', 1, 35419)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35421, 35418, 35420, N'N', 1, 35423)
GO
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35425, 35422, 35424, N'N', 1, 35427)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35429, 35426, 35428, N'N', 1, 35431)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35433, 35430, 35432, N'N', 1, 35435)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35437, 35434, 35436, N'N', 1, 35439)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35441, 35438, 35440, N'N', 1, 35443)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35445, 35442, 35444, N'N', 1, 35447)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35449, 35446, 35448, N'N', 1, 35451)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35453, 35450, 35452, N'N', 1, 35455)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35457, 35454, 35456, N'N', 1, 35459)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35461, 35458, 35460, N'N', 1, 35463)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35465, 35462, 35464, N'N', 1, 35467)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35469, 35466, 35468, N'N', 1, 35471)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35473, 35470, 35472, N'N', 1, 35475)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35477, 35474, 35476, N'N', 1, 35479)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35481, 35478, 35480, N'N', 1, 35483)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35485, 35482, 35484, N'N', 1, 35487)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35489, 35486, 35488, N'N', 1, 35491)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35493, 35490, 35492, N'N', 1, 35495)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35497, 35494, 35496, N'N', 1, 35499)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35501, 35498, 35500, N'N', 1, 35503)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35505, 35502, 35504, N'N', 1, 35507)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35509, 35506, 35508, N'N', 1, 35511)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35513, 35510, 35512, N'N', 1, 35515)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35517, 35514, 35516, N'N', 1, 35519)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35521, 35518, 35520, N'N', 1, 35523)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35525, 35522, 35524, N'N', 1, 35527)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35529, 35526, 35528, N'N', 1, 35531)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35533, 35530, 35532, N'N', 1, 35535)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35537, 35534, 35536, N'N', 1, 35539)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35541, 35538, 35540, N'N', 1, 35543)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35545, 35542, 35544, N'N', 1, 35547)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35549, 35546, 35548, N'N', 1, 35551)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35553, 35550, 35552, N'N', 1, 35555)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35557, 35554, 35556, N'N', 1, 35559)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35561, 35558, 35560, N'N', 1, 35563)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35565, 35562, 35564, N'N', 1, 35567)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35569, 35566, 35568, N'N', 1, 35571)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35573, 35570, 35572, N'N', 1, 35575)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35577, 35574, 35576, N'N', 1, 35579)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35581, 35578, 35580, N'N', 1, 35583)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35585, 35582, 35584, N'N', 1, 35587)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35589, 35586, 35588, N'N', 1, 35591)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35593, 35590, 35592, N'N', 1, 35595)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35597, 35594, 35596, N'N', 1, 35599)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35601, 35598, 35600, N'N', 1, 35603)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35605, 35602, 35604, N'N', 1, 35607)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35609, 35606, 35608, N'N', 1, 35611)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35613, 35610, 35612, N'N', 1, 35615)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35617, 35614, 35616, N'N', 1, 35619)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35621, 35618, 35620, N'N', 1, 35623)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35625, 35622, 35624, N'N', 1, 35627)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35629, 35626, 35628, N'N', 1, 35631)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35633, 35630, 35632, N'N', 1, 35635)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35637, 35634, 35636, N'N', 1, 35639)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35641, 35638, 35640, N'N', 1, 35643)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35645, 35642, 35644, N'N', 1, 35647)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35649, 35646, 35648, N'N', 1, 35651)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35653, 35650, 35652, N'N', 1, 35655)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35657, 35654, 35656, N'N', 1, 35659)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35661, 35658, 35660, N'N', 1, 35663)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35665, 35662, 35664, N'N', 1, 35667)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35669, 35666, 35668, N'N', 1, 35671)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35673, 35670, 35672, N'N', 1, 35675)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35677, 35674, 35676, N'N', 1, 35679)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35681, 35678, 35680, N'N', 1, 35683)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35685, 35682, 35684, N'N', 1, 35687)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35689, 35686, 35688, N'N', 1, 35691)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35693, 35690, 35692, N'N', 1, 35695)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35697, 35694, 35696, N'N', 1, 35699)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35701, 35698, 35700, N'N', 1, 35703)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35705, 35702, 35704, N'N', 1, 35707)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35709, 35706, 35708, N'N', 1, 35711)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35713, 35710, 35712, N'N', 1, 35715)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35717, 35714, 35716, N'N', 1, 35719)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35721, 35718, 35720, N'N', 1, 35723)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35725, 35722, 35724, N'N', 1, 35727)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35729, 35726, 35728, N'N', 1, 35731)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35733, 35730, 35732, N'N', 1, 35735)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35737, 35734, 35736, N'N', 1, 35739)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35741, 35738, 35740, N'N', 1, 35743)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35745, 35742, 35744, N'N', 1, 35747)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35749, 35746, 35748, N'N', 1, 35751)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35753, 35750, 35752, N'N', 1, 35755)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35757, 35754, 35756, N'N', 1, 35759)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35761, 35758, 35760, N'N', 1, 35763)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35765, 35762, 35764, N'N', 1, 35767)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35769, 35766, 35768, N'N', 1, 35771)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35773, 35770, 35772, N'N', 1, 35775)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35777, 35774, 35776, N'N', 1, 35779)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35781, 35778, 35780, N'N', 1, 35783)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35785, 35782, 35784, N'N', 1, 35787)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35789, 35786, 35788, N'N', 1, 35791)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35793, 35790, 35792, N'N', 1, 35795)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35797, 35794, 35796, N'N', 1, 35799)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35801, 35798, 35800, N'N', 1, 35803)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35805, 35802, 35804, N'N', 1, 35807)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35809, 35806, 35808, N'N', 1, 35811)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35813, 35810, 35812, N'N', 1, 35815)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35817, 35814, 35816, N'N', 1, 35819)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35821, 35818, 35820, N'N', 1, 35823)
GO
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35825, 35822, 35824, N'N', 1, 35827)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35829, 35826, 35828, N'N', 1, 35831)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35833, 35830, 35832, N'N', 1, 35835)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35837, 35834, 35836, N'N', 1, 35839)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35841, 35838, 35840, N'N', 1, 35843)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35845, 35842, 35844, N'N', 1, 35847)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35849, 35846, 35848, N'N', 1, 35851)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35853, 35850, 35852, N'N', 1, 35855)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35857, 35854, 35856, N'N', 1, 35859)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35861, 35858, 35860, N'N', 1, 35863)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35865, 35862, 35864, N'N', 1, 35867)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35869, 35866, 35868, N'N', 1, 35871)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35873, 35870, 35872, N'N', 1, 35875)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35877, 35874, 35876, N'N', 1, 35879)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35881, 35878, 35880, N'N', 1, 35883)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35885, 35882, 35884, N'N', 1, 35887)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35889, 35886, 35888, N'N', 1, 35891)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35893, 35890, 35892, N'N', 1, 35895)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35897, 35894, 35896, N'N', 1, 35899)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35901, 35898, 35900, N'N', 1, 35903)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35905, 35902, 35904, N'N', 1, 35907)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35909, 35906, 35908, N'N', 1, 35911)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35913, 35910, 35912, N'N', 1, 35915)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35917, 35914, 35916, N'N', 1, 35919)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35921, 35918, 35920, N'N', 1, 35923)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35925, 35922, 35924, N'N', 1, 35927)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35929, 35926, 35928, N'N', 1, 35931)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35933, 35930, 35932, N'N', 1, 35935)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35937, 35934, 35936, N'N', 1, 35939)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35941, 35938, 35940, N'N', 1, 35943)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35945, 35942, 35944, N'N', 1, 35947)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35949, 35946, 35948, N'N', 1, 35951)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35953, 35950, 35952, N'N', 1, 35955)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35957, 35954, 35956, N'N', 1, 35959)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35961, 35958, 35960, N'N', 1, 35963)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35965, 35962, 35964, N'N', 1, 35967)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35969, 35966, 35968, N'N', 1, 35971)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35973, 35970, 35972, N'N', 1, 35975)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35977, 35974, 35976, N'N', 1, 35979)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35981, 35978, 35980, N'N', 1, 35983)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35985, 35982, 35984, N'N', 1, 35987)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35989, 35986, 35988, N'N', 1, 35991)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35993, 35990, 35992, N'N', 1, 35995)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (35997, 35994, 35996, N'N', 1, 35999)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36001, 35998, 36000, N'N', 1, 36003)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36005, 36002, 36004, N'N', 1, 36007)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36009, 36006, 36008, N'N', 1, 36011)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36013, 36010, 36012, N'N', 1, 36015)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36017, 36014, 36016, N'N', 1, 36019)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36021, 36018, 36020, N'N', 1, 36023)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36025, 36022, 36024, N'N', 1, 36027)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36029, 36026, 36028, N'N', 1, 36031)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36033, 36030, 36032, N'N', 1, 36035)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36037, 36034, 36036, N'N', 1, 36039)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36041, 36038, 36040, N'N', 1, 36043)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36045, 36042, 36044, N'N', 1, 36047)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36049, 36046, 36048, N'N', 1, 36051)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36053, 36050, 36052, N'N', 1, 36055)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36057, 36054, 36056, N'N', 1, 36059)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36061, 36058, 36060, N'N', 1, 36063)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36065, 36062, 36064, N'N', 1, 36067)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36069, 36066, 36068, N'N', 1, 36071)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36073, 36070, 36072, N'N', 1, 36075)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36077, 36074, 36076, N'N', 1, 36079)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36081, 36078, 36080, N'N', 1, 36083)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36085, 36082, 36084, N'N', 1, 36087)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36089, 36086, 36088, N'N', 1, 36091)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36093, 36090, 36092, N'N', 1, 36095)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36097, 36094, 36096, N'N', 1, 36099)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36101, 36098, 36100, N'N', 1, 36103)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36105, 36102, 36104, N'N', 1, 36107)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36109, 36106, 36108, N'N', 1, 36111)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36113, 36110, 36112, N'N', 1, 36115)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36117, 36114, 36116, N'N', 1, 36119)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36121, 36118, 36120, N'N', 1, 36123)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36125, 36122, 36124, N'N', 1, 36127)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36129, 36126, 36128, N'N', 1, 36131)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36133, 36130, 36132, N'N', 1, 36135)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36137, 36134, 36136, N'N', 1, 36139)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36141, 36138, 36140, N'N', 1, 36143)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36145, 36142, 36144, N'N', 1, 36147)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36149, 36146, 36148, N'N', 1, 36151)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36153, 36150, 36152, N'N', 1, 36155)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36157, 36154, 36156, N'N', 1, 36159)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36161, 36158, 36160, N'N', 1, 36163)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36165, 36162, 36164, N'N', 1, 36167)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36169, 36166, 36168, N'N', 1, 36171)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36173, 36170, 36172, N'N', 1, 36175)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36177, 36174, 36176, N'N', 1, 36179)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36181, 36178, 36180, N'N', 1, 36183)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36185, 36182, 36184, N'N', 1, 36187)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36189, 36186, 36188, N'N', 1, 36191)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36193, 36190, 36192, N'N', 1, 36195)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36197, 36194, 36196, N'N', 1, 36199)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36201, 36198, 36200, N'N', 1, 36203)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36205, 36202, 36204, N'N', 1, 36207)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36209, 36206, 36208, N'N', 1, 36211)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36213, 36210, 36212, N'N', 1, 36215)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36217, 36214, 36216, N'N', 1, 36219)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36221, 36218, 36220, N'N', 1, 36223)
GO
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36225, 36222, 36224, N'N', 1, 36227)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36229, 36226, 36228, N'N', 1, 36231)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36233, 36230, 36232, N'N', 1, 36235)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36237, 36234, 36236, N'N', 1, 36239)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36241, 36238, 36240, N'N', 1, 36243)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36245, 36242, 36244, N'N', 1, 36247)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36249, 36246, 36248, N'N', 1, 36251)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36253, 36250, 36252, N'N', 1, 36255)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36257, 36254, 36256, N'N', 1, 36259)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36261, 36258, 36260, N'N', 1, 36263)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36265, 36262, 36264, N'N', 1, 36267)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36269, 36266, 36268, N'N', 1, 36271)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36273, 36270, 36272, N'N', 1, 36275)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36277, 36274, 36276, N'N', 1, 36279)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36281, 36278, 36280, N'N', 1, 36283)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36285, 36282, 36284, N'N', 1, 36287)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36289, 36286, 36288, N'N', 1, 36291)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36293, 36290, 36292, N'N', 1, 36295)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36297, 36294, 36296, N'N', 1, 36299)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36301, 36298, 36300, N'N', 1, 36303)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36952, 36949, 36951, N'N', 1, 36954)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36956, 36953, 36955, N'N', 1, 36958)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36960, 36957, 36959, N'N', 1, 36962)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36964, 36961, 36963, N'N', 1, 36966)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36968, 36965, 36967, N'N', 1, 36970)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36972, 36969, 36971, N'N', 1, 36974)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36976, 36973, 36975, N'N', 1, 36978)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36980, 36977, 36979, N'N', 1, 36982)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36984, 36981, 36983, N'N', 1, 36986)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36988, 36985, 36987, N'N', 1, 36990)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36992, 36989, 36991, N'N', 1, 36994)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (36996, 36993, 36995, N'N', 1, 36998)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37000, 36997, 36999, N'N', 1, 37002)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37004, 37001, 37003, N'N', 1, 37006)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37008, 37005, 37007, N'N', 1, 37010)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37012, 37009, 37011, N'N', 1, 37014)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37016, 37013, 37015, N'N', 1, 37018)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37020, 37017, 37019, N'N', 1, 37022)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37024, 37021, 37023, N'N', 1, 37026)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37028, 37025, 37027, N'N', 1, 37030)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37032, 37029, 37031, N'N', 1, 37034)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37036, 37033, 37035, N'N', 1, 37038)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37040, 37037, 37039, N'N', 1, 37042)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37044, 37041, 37043, N'N', 1, 37046)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37048, 37045, 37047, N'N', 1, 37050)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37052, 37049, 37051, N'N', 1, 37054)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37056, 37053, 37055, N'N', 1, 37058)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37060, 37057, 37059, N'N', 1, 37062)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37064, 37061, 37063, N'N', 1, 37066)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37068, 37065, 37067, N'N', 1, 37070)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37072, 37069, 37071, N'N', 1, 37074)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37076, 37073, 37075, N'N', 1, 37078)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37080, 37077, 37079, N'N', 1, 37082)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37084, 37081, 37083, N'N', 1, 37086)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37088, 37085, 37087, N'N', 1, 37090)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37092, 37089, 37091, N'N', 1, 37094)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37096, 37093, 37095, N'N', 1, 37098)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37100, 37097, 37099, N'N', 1, 37102)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37104, 37101, 37103, N'N', 1, 37106)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37108, 37105, 37107, N'N', 1, 37110)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37112, 37109, 37111, N'N', 1, 37114)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37116, 37113, 37115, N'N', 1, 37118)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37120, 37117, 37119, N'N', 1, 37122)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37124, 37121, 37123, N'N', 1, 37126)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37128, 37125, 37127, N'N', 1, 37130)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37132, 37129, 37131, N'N', 1, 37134)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37136, 37133, 37135, N'N', 1, 37138)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37140, 37137, 37139, N'N', 1, 37142)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37144, 37141, 37143, N'N', 1, 37146)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37148, 37145, 37147, N'N', 1, 37150)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37152, 37149, 37151, N'N', 1, 37154)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37156, 37153, 37155, N'N', 1, 37158)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37160, 37157, 37159, N'N', 1, 37162)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37164, 37161, 37163, N'N', 1, 37166)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37168, 37165, 37167, N'N', 1, 37170)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37172, 37169, 37171, N'N', 1, 37174)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37176, 37173, 37175, N'N', 1, 37178)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37180, 37177, 37179, N'N', 1, 37182)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37184, 37181, 37183, N'N', 1, 37186)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37188, 37185, 37187, N'N', 1, 37190)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37192, 37189, 37191, N'N', 1, 37194)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37196, 37193, 37195, N'N', 1, 37198)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37200, 37197, 37199, N'N', 1, 37202)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37204, 37201, 37203, N'N', 1, 37206)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37208, 37205, 37207, N'N', 1, 37210)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37212, 37209, 37211, N'N', 1, 37214)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37216, 37213, 37215, N'N', 1, 37218)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37220, 37217, 37219, N'N', 1, 37222)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37224, 37221, 37223, N'N', 1, 37226)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37228, 37225, 37227, N'N', 1, 37230)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37232, 37229, 37231, N'N', 1, 37234)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37236, 37233, 37235, N'N', 1, 37238)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37240, 37237, 37239, N'N', 1, 37242)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37244, 37241, 37243, N'N', 1, 37246)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37248, 37245, 37247, N'N', 1, 37250)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37252, 37249, 37251, N'N', 1, 37254)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37256, 37253, 37255, N'N', 1, 37258)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37260, 37257, 37259, N'N', 1, 37262)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37264, 37261, 37263, N'N', 1, 37266)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37268, 37265, 37267, N'N', 1, 37270)
GO
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37272, 37269, 37271, N'N', 1, 37274)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37276, 37273, 37275, N'N', 1, 37278)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37280, 37277, 37279, N'N', 1, 37282)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37284, 37281, 37283, N'N', 1, 37286)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37288, 37285, 37287, N'N', 1, 37290)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37292, 37289, 37291, N'N', 1, 37294)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37296, 37293, 37295, N'N', 1, 37298)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37300, 37297, 37299, N'N', 1, 37302)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37304, 37301, 37303, N'N', 1, 37306)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37308, 37305, 37307, N'N', 1, 37310)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37312, 37309, 37311, N'N', 1, 37314)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37316, 37313, 37315, N'N', 1, 37318)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37320, 37317, 37319, N'N', 1, 37322)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37324, 37321, 37323, N'N', 1, 37326)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37328, 37325, 37327, N'N', 1, 37330)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37332, 37329, 37331, N'N', 1, 37334)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37336, 37333, 37335, N'N', 1, 37338)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37340, 37337, 37339, N'N', 1, 37342)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37344, 37341, 37343, N'N', 1, 37346)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37348, 37345, 37347, N'N', 1, 37350)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37352, 37349, 37351, N'N', 1, 37354)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37356, 37353, 37355, N'N', 1, 37358)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37360, 37357, 37359, N'N', 1, 37362)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37364, 37361, 37363, N'N', 1, 37366)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37368, 37365, 37367, N'N', 1, 37370)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37372, 37369, 37371, N'N', 1, 37374)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37376, 37373, 37375, N'N', 1, 37378)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37380, 37377, 37379, N'N', 1, 37382)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37384, 37381, 37383, N'N', 1, 37386)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37388, 37385, 37387, N'N', 1, 37390)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37392, 37389, 37391, N'N', 1, 37394)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37396, 37393, 37395, N'N', 1, 37398)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37400, 37397, 37399, N'N', 1, 37402)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37404, 37401, 37403, N'N', 1, 37406)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37408, 37405, 37407, N'N', 1, 37410)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37412, 37409, 37411, N'N', 1, 37414)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37416, 37413, 37415, N'N', 1, 37418)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37420, 37417, 37419, N'N', 1, 37422)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37424, 37421, 37423, N'N', 1, 37426)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37428, 37425, 37427, N'N', 1, 37430)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37432, 37429, 37431, N'N', 1, 37434)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37436, 37433, 37435, N'N', 1, 37438)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37440, 37437, 37439, N'N', 1, 37442)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37444, 37441, 37443, N'N', 1, 37446)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37448, 37445, 37447, N'N', 1, 37450)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37452, 37449, 37451, N'N', 1, 37454)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37456, 37453, 37455, N'N', 1, 37458)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37460, 37457, 37459, N'N', 1, 37462)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37464, 37461, 37463, N'N', 1, 37466)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37468, 37465, 37467, N'N', 1, 37470)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37472, 37469, 37471, N'N', 1, 37474)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37476, 37473, 37475, N'N', 1, 37478)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37480, 37477, 37479, N'N', 1, 37482)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37484, 37481, 37483, N'N', 1, 37486)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37488, 37485, 37487, N'N', 1, 37490)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37492, 37489, 37491, N'N', 1, 37494)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37496, 37493, 37495, N'N', 1, 37498)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37500, 37497, 37499, N'N', 1, 37502)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37504, 37501, 37503, N'N', 1, 37506)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37508, 37505, 37507, N'N', 1, 37510)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37512, 37509, 37511, N'N', 1, 37514)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37516, 37513, 37515, N'N', 1, 37518)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (37520, 37517, 37519, N'N', 1, 37522)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55703, 55700, 55702, N'N', 3, 55705)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55707, 55704, 55706, N'N', 3, 55709)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55711, 55708, 55710, N'N', 3, 55713)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55715, 55712, 55714, N'N', 3, 55717)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55719, 55716, 55718, N'N', 3, 55721)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55723, 55720, 55722, N'N', 3, 55725)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55727, 55724, 55726, N'N', 3, 55729)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55731, 55728, 55730, N'N', 3, 55733)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55735, 55732, 55734, N'N', 3, 55737)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55739, 55736, 55738, N'N', 3, 55741)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55743, 55740, 55742, N'N', 3, 55745)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55747, 55744, 55746, N'N', 3, 55749)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55751, 55748, 55750, N'N', 3, 55753)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55755, 55752, 55754, N'N', 3, 55757)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55759, 55756, 55758, N'N', 3, 55761)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55763, 55760, 55762, N'N', 3, 55765)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55767, 55764, 55766, N'N', 3, 55769)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55771, 55768, 55770, N'N', 3, 55773)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55775, 55772, 55774, N'N', 3, 55777)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55779, 55776, 55778, N'N', 3, 55781)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55783, 55780, 55782, N'N', 3, 55785)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55787, 55784, 55786, N'N', 3, 55789)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55791, 55788, 55790, N'N', 3, 55793)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55795, 55792, 55794, N'N', 3, 55797)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55799, 55796, 55798, N'N', 3, 55801)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55803, 55800, 55802, N'N', 3, 55805)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55807, 55804, 55806, N'N', 3, 55809)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55811, 55808, 55810, N'N', 3, 55813)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55815, 55812, 55814, N'N', 3, 55817)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55819, 55816, 55818, N'N', 3, 55821)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55823, 55820, 55822, N'N', 3, 55825)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55827, 55824, 55826, N'N', 3, 55829)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55831, 55828, 55830, N'N', 3, 55833)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55835, 55832, 55834, N'N', 3, 55837)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55839, 55836, 55838, N'N', 3, 55841)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55843, 55840, 55842, N'N', 3, 55845)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55847, 55844, 55846, N'N', 3, 55849)
GO
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55851, 55848, 55850, N'N', 3, 55853)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55855, 55852, 55854, N'N', 3, 55857)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55859, 55856, 55858, N'N', 3, 55861)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55863, 55860, 55862, N'N', 3, 55865)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55867, 55864, 55866, N'N', 3, 55869)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55871, 55868, 55870, N'N', 3, 55873)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55875, 55872, 55874, N'N', 3, 55877)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55879, 55876, 55878, N'N', 3, 55881)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55883, 55880, 55882, N'N', 3, 55885)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55887, 55884, 55886, N'N', 3, 55889)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55891, 55888, 55890, N'N', 3, 55893)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55895, 55892, 55894, N'N', 3, 55897)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55899, 55896, 55898, N'N', 3, 55901)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55903, 55900, 55902, N'N', 3, 55905)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55907, 55904, 55906, N'N', 3, 55909)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55911, 55908, 55910, N'N', 3, 55913)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55915, 55912, 55914, N'N', 3, 55917)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55919, 55916, 55918, N'N', 3, 55921)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55923, 55920, 55922, N'N', 3, 55925)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55927, 55924, 55926, N'N', 3, 55929)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55931, 55928, 55930, N'N', 3, 55933)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55935, 55932, 55934, N'N', 3, 55937)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55939, 55936, 55938, N'N', 3, 55941)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55943, 55940, 55942, N'N', 3, 55945)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55947, 55944, 55946, N'N', 3, 55949)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55951, 55948, 55950, N'N', 3, 55953)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55955, 55952, 55954, N'N', 3, 55957)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55959, 55956, 55958, N'N', 3, 55961)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55963, 55960, 55962, N'N', 3, 55965)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55967, 55964, 55966, N'N', 3, 55969)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55971, 55968, 55970, N'N', 3, 55973)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55975, 55972, 55974, N'N', 3, 55977)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55979, 55976, 55978, N'N', 3, 55981)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55983, 55980, 55982, N'N', 3, 55985)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55987, 55984, 55986, N'N', 3, 55989)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55991, 55988, 55990, N'N', 3, 55993)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55995, 55992, 55994, N'N', 3, 55997)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (55999, 55996, 55998, N'N', 3, 56001)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56003, 56000, 56002, N'N', 3, 56005)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56007, 56004, 56006, N'N', 3, 56009)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56011, 56008, 56010, N'N', 3, 56013)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56015, 56012, 56014, N'N', 3, 56017)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56019, 56016, 56018, N'N', 3, 56021)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56023, 56020, 56022, N'N', 3, 56025)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56027, 56024, 56026, N'N', 3, 56029)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56031, 56028, 56030, N'N', 3, 56033)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56035, 56032, 56034, N'N', 3, 56037)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56039, 56036, 56038, N'N', 3, 56041)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56043, 56040, 56042, N'N', 3, 56045)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56047, 56044, 56046, N'N', 3, 56049)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56051, 56048, 56050, N'N', 3, 56053)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56055, 56052, 56054, N'N', 3, 56057)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56059, 56056, 56058, N'N', 3, 56061)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56063, 56060, 56062, N'N', 3, 56065)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56067, 56064, 56066, N'N', 3, 56069)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56071, 56068, 56070, N'N', 3, 56073)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56075, 56072, 56074, N'N', 3, 56077)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56079, 56076, 56078, N'N', 3, 56081)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56083, 56080, 56082, N'N', 3, 56085)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56087, 56084, 56086, N'N', 3, 56089)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56091, 56088, 56090, N'N', 3, 56093)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56095, 56092, 56094, N'N', 3, 56097)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56099, 56096, 56098, N'N', 3, 56101)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56103, 56100, 56102, N'N', 3, 56105)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56107, 56104, 56106, N'N', 3, 56109)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56111, 56108, 56110, N'N', 3, 56113)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56115, 56112, 56114, N'N', 3, 56117)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56119, 56116, 56118, N'N', 3, 56121)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56123, 56120, 56122, N'N', 3, 56125)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56127, 56124, 56126, N'N', 3, 56129)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56131, 56128, 56130, N'N', 3, 56133)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56135, 56132, 56134, N'N', 3, 56137)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56139, 56136, 56138, N'N', 3, 56141)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56143, 56140, 56142, N'N', 3, 56145)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56147, 56144, 56146, N'N', 3, 56149)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56151, 56148, 56150, N'N', 3, 56153)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56155, 56152, 56154, N'N', 3, 56157)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56159, 56156, 56158, N'N', 3, 56161)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56163, 56160, 56162, N'N', 3, 56165)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56167, 56164, 56166, N'N', 3, 56169)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56171, 56168, 56170, N'N', 3, 56173)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56175, 56172, 56174, N'N', 3, 56177)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56179, 56176, 56178, N'N', 3, 56181)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56183, 56180, 56182, N'N', 3, 56185)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56187, 56184, 56186, N'N', 3, 56189)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56191, 56188, 56190, N'N', 3, 56193)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56195, 56192, 56194, N'N', 3, 56197)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56199, 56196, 56198, N'N', 3, 56201)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56203, 56200, 56202, N'N', 3, 56205)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56207, 56204, 56206, N'N', 3, 56209)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56211, 56208, 56210, N'N', 3, 56213)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56215, 56212, 56214, N'N', 3, 56217)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56219, 56216, 56218, N'N', 3, 56221)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56223, 56220, 56222, N'N', 3, 56225)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56227, 56224, 56226, N'N', 3, 56229)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56231, 56228, 56230, N'N', 3, 56233)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56235, 56232, 56234, N'N', 3, 56237)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56239, 56236, 56238, N'N', 3, 56241)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56243, 56240, 56242, N'N', 3, 56245)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56247, 56244, 56246, N'N', 3, 56249)
GO
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56251, 56248, 56250, N'N', 3, 56253)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56255, 56252, 56254, N'N', 3, 56257)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56259, 56256, 56258, N'N', 3, 56261)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56263, 56260, 56262, N'N', 3, 56265)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56267, 56264, 56266, N'N', 3, 56269)
INSERT [dbo].[Task_Crane_rely] ([taskId], [relyId], [completeId], [tight], [DeviceId], [id]) VALUES (56271, 56268, 56270, N'N', 3, 56273)
ALTER TABLE [dbo].[Task_Crane] ADD  CONSTRAINT [DF__Crane_Tas__Prior__22AA2996]  DEFAULT ((10)) FOR [Priority]
GO
/****** Object:  StoredProcedure [dbo].[_BBTaskNo]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[_BBTaskNo] 


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE	@date date;
	DECLARE @now  date;
	DECLARE @value int;
	DECLARE @begin varchar(6);
	SET @now =  GETDATE();
	SET NOCOUNT ON;
	 SELECT @value=value FROM dbo.BBTaskNo WHERE dateline= @now
	 if @value is null
	 begin
		 set @begin = CONVERT(varchar(6), GETDATE(), 12)
		 set @value= convert(int,right( @begin,4))*100000;

		 set @value=@value+1;
		 insert into  dbo.BBTaskNo(dateline,value) values(@now,@value);
	 end else begin
		  set @value=@value+1;
		  UPDATE dbo.BBTaskNo SET value=@value WHERE dateline=@now;
	 end
     return @value;
END








GO
/****** Object:  StoredProcedure [dbo].[_BCarrier]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[_BCarrier]--单表操作，无事务
	(
		@completeId bigint,
		@code varchar(50),
		@StartPath SMALLINT,
        @EndPath SMALLINT,
		 @TaskNo int
	)
AS
BEGIN
	DECLARE	@id bigint ;
	DECLARE @now datetime;
	DECLARE @extra varchar(50);
    SET @now =  GETDATE();

	Set @extra =@code+'从'+ convert(varchar(4),@StartPath) +'搬运到'+ convert(varchar(4),@EndPath);
	if @TaskNo =0 begin
		raiserror('bcarrier error %d',16,1,@completeId) 
	end
  SELECT @id= NEXT VALUE FOR [sequence_id]; 
	INSERT INTO [dbo].[Task_Carrier](id,TaskNo,StartPath,EndPath,status,completeId,StartTime,code,Extra)
	 VALUES(@id,@TaskNo,@StartPath,@EndPath,1,@completeId,@now,@code,@extra);
	return @id;
END








GO
/****** Object:  StoredProcedure [dbo].[_bComplete]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[_bComplete](
	@taskid bigint ,
	@Src  INT,
	@des  INT,
	@taskType int,
	@relyTaskId bigint,
	@boxCode varchar(50),
	@itemType int

	)
AS
BEGIN
  DECLARE @now datetime;
  DECLARE @info varchar(100);

  DECLARE @id bigint;
  SET @now =  GETDATE();
  
		if @taskType =1  --入库
		begin
				set @info = '入库'
		end else if  @taskType =2--出库
		begin
				set @info = '出库'
		end else if  @taskType =3--移库
		begin
				set @info = '移库'
		end 
  
select @id = next value for sequence_id ;
INSERT INTO [dbo].[Task_complete] (id,[type], [createTime],   [src], [des],status,wmsTaskId,info,relyTaskId,boxCode,itemType)
    VALUES (@id,@taskType,@now,@Src,@des,1,@taskid,@info,@relyTaskId,@boxCode,@itemType)
	

	return @id;
		
			

END






GO
/****** Object:  StoredProcedure [dbo].[_BCrane]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[_BCrane]
	(
		@completeId bigint,
		@locId bigint,
		@type int, --1 入库，2 出库，3 移库,4摆渡，只是从垛机经过
		@MotionType SMALLINT,--1取货，2放货
		@code varchar(30),
		@TaskNo int,
		@itemType int--光纤库，成品库， 1 窄，2 宽
	)
AS
BEGIN

	DECLARE @locX INT;
	DECLARE @locY INT;  
	DECLARE @locZ INT;  
	DECLARE @locDir INT;
	DECLARE	@id bigint ;
	DECLARE	@craneId  SMALLINT;

	DECLARE @Extra varchar(50);
	

   if @type=1 begin
   set @Extra='入库'
   end else if @type=2 begin
     set @Extra='出库'
   end else if @type=3 begin
     set @Extra='移库'
   end else if @type=4 begin
     set @Extra='摆渡'
   end else begin
		raiserror('at _BCrane,type is [%d]  error',16,1,@type)
   end

   if @MotionType=1 begin
	set @Extra=@Extra+'取货'
   end  else if @MotionType=2 begin
	set @Extra=@Extra+'放货'
   end 
   	set @Extra=@Extra+'--'+convert(varchar(10),@locId)+'--'+@code
 
	--变量赋值
	if @locId>100000 begin--带序号货位
		SELECT @locX=X,@locY=Y,@locDir=Direction,@locZ=deep ,@craneId= craneId FROM dbo.physical_Location WHERE  id=@locId/100
		select @locX=@locX-dbo._getLocOffset(@locId%100,@itemType%10)
	end  else if @locId>10000  begin--正常货位
		SELECT @locX=X,@locY=Y,@locDir=Direction,@locZ=deep ,@craneId= craneId FROM dbo.physical_Location WHERE id= @locId 
	end else begin--传输线节号 
	SELECT @locX=X,@locY=Y,@locDir=Direction,@locZ=deep ,@craneId= craneId FROM dbo.physical_Location WHERE id= @locId*10+1 
	end

	
    SELECT @id= NEXT VALUE FOR [sequence_id]; 
	
	INSERT INTO [dbo].[Task_Crane](id,TaskNo,locX, locY,locZ, locDir, locId, Status, Priority, MotionType, StartTime,Extra,completeId,craneId,type,code,forkno,itemType)
	VALUES(@id,@TaskNo,@locX,@locY,@locZ,@locDir,@locId,1,5,@MotionType,GETDATE(),@Extra,@completeId,@craneId,@type,@code,0,@itemType);
	return @id;
END









GO
/****** Object:  StoredProcedure [dbo].[_BCraneRely]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[_BCraneRely]
	(@completeId bigint,
	@taskId bigint,
	@relyId bigint,
	@tight varchar(2),--Y 紧凑执行，N 非紧凑
	@DeviceId smallint
	)
AS
BEGIN
DECLARE	@id bigint;
if @relyId>0
	begin
	  SELECT @id= NEXT VALUE FOR [sequence_id]; 
	 insert into  [dbo].[task_crane_rely](id,taskId,[relyId],completeId,tight,DeviceId) values(@id,@taskId,@relyId,@completeId,@tight,@DeviceId);
	end
END









GO
/****** Object:  StoredProcedure [dbo].[_BHuman]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [dbo].[_BHuman]--单表操作，无事务
	(
		@completeId bigint,
		@code varchar(50),
		@endPath int
		
	)
AS
BEGIN
	DECLARE	@id bigint ;
	DECLARE @now datetime;
	DECLARE	@TaskNo int;
    SET @now =  GETDATE();
  exec @TaskNo=  dbo._BBTaskNo    
    SELECT @id= NEXT VALUE FOR [sequence_id]; 
	INSERT INTO [dbo].[Task_human] (id,[completeId] ,[TaskNo]  ,[Status] ,[createDate],[Extra] ,[Code],stn)
     VALUES (@id,@completeId ,@TaskNo ,1,@now,'人工pda确认' ,@code,@endPath)
	 return @id;
END








GO
/****** Object:  StoredProcedure [dbo].[_BMechineHand]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[_BMechineHand]--单表操作，无事务
	(
		@completeId bigint,
		@code varchar(50),
		@StartPath SMALLINT,
        @EndPath SMALLINT,
		@TaskNo int
	)
AS
BEGIN
	DECLARE	@id bigint ;
	DECLARE @now datetime;
	DECLARE @extra varchar(50);
    SET @now =  GETDATE();

	Set @extra ='机械手'+@code+'从'+ convert(varchar(4),@StartPath) +'搬运到'+ convert(varchar(4),@EndPath);
	if @TaskNo =0 begin
		raiserror('bcarrier error %d',16,1,@completeId) 
	end
  SELECT @id= NEXT VALUE FOR [sequence_id]; 
	INSERT INTO [dbo].[Task_MechineHand](id,TaskNo,StartPath,EndPath,status,completeId,StartTime,code,Extra)
	 VALUES(@id,@TaskNo,@StartPath,@EndPath,1,@completeId,@now,@code,@extra);
	return @id;
END








GO
/****** Object:  StoredProcedure [dbo].[_WCompleteDelete]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[_WCompleteDelete]
	(
		@completeId bigint

	)
AS
BEGIN


	DECLARE @now datetime;
	DECLARE @wmsTaskId bigint;
	DECLARE @count bigint;
	DECLARE @taskType int;
    DECLARE @stockId bigint;
	DECLARE @DesID bigint;
    DECLARE @SrcID bigint;
		
	
    SET @now =  GETDATE();

	  SELECT @count = count(*)  FROM [Task_Crane]  where status<>1 and completeId=@completeId
	  if @count<>0 begin
			return 1;
	  end

	update Task_Crane set status=-1 where completeId=@completeId;
	update Task_carrier  set status=-1 where completeId=@completeId;
	update Task_complete  set status=-1 ,endTime = @now where id=@completeId;
	return 2;


END









GO
/****** Object:  StoredProcedure [dbo].[_WCompleteFinish]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[_WCompleteFinish]
	(
		@completeId bigint

	)
AS
BEGIN
	DECLARE @count int;
	DECLARE @now datetime;
    SET @now =  GETDATE();

	SELECT  @count = count(*)  FROM [Task_Carrier] where completeId=@completeId and status<>3
	if @count<>0 begin
		return 1;--'carrier working';
	end

	SELECT @count = count(*) FROM [Task_Crane]  where completeId=@completeId and status<>7 and status<>9
	if @count<>0 begin
		return 2;--'Crane working';
	end
	
	SELECT @count = count(*) FROM Task_human  where completeId=@completeId and status<>3
	if @count<>0 begin
		return 3;--'human working';
	end

	update Task_complete  set status=3 ,endTime = @now where id=@completeId
	return 4;		

END









GO
/****** Object:  StoredProcedure [dbo].[_WCreateIn]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[_WCreateIn](
	@wmstaskid bigint,
	@srcId int,
	@desId int,
	@boxCode varchar(50),
	@itemType int
	)
AS
BEGIN

	DECLARE @completeId bigint;

	DECLARE @carrierEnd bigint;

	--DECLARE @Thickness smallint;
	--set @Thickness=@itemType%10;
		DECLARE @count bigint;
DECLARE @TaskNo bigint;
	SELECT @count = count(*) FROM [Task_complete]  where wmsTaskId =@wmsTaskId
	if @count<>0 begin
	   return 1--'ok';
	end
	exec @completeId = [dbo].[_bComplete] @wmstaskid ,@SrcID,@desID, 1 ,null ,@boxCode,@itemType
	select @carrierEnd= [dbo].[_getInstockEndCarrier] (@SrcID,@desID)
	exec @TaskNo = dbo._BBTaskNo  ;
	exec [dbo].[_BCarrier] @completeId, @boxCode, @SrcID,@carrierEnd,@TaskNo
	exec dbo._BCrane  @completeId , @carrierEnd, 1,1,@boxCode,@TaskNo,@itemType
	exec @TaskNo = dbo._BBTaskNo  ;
	exec dbo._BCrane  @completeId , @desID ,1,2 ,@boxCode,@TaskNo,@itemType
		
	
	
	update [dbo].[Task_complete] set status=2 where id=@completeId--状态设置为计划结束
	return 2--'ok';
END
--UPDATE t1   SET  t1.Status=1  FROM  [sl_wms]. [dbo].[loc_stock] t1  WHERE EXISTS ( SELECT 1 FROM [sl_wms].[dbo].[Task_liku] t2  WHERE t1.ID=t2.stockId AND t2.id=@taskid);
		





GO
/****** Object:  StoredProcedure [dbo].[_WCreateMove]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[_WCreateMove](
	@wmsTaskId bigint ,
	@SrcID  INT,
	@desID  INT,
	@boxCode varchar(50),
	@relyTaskId bigint,
	@itemType int
	)
AS
BEGIN

	DECLARE @id bigint;
	DECLARE @relyComleteId bigint;
	DECLARE @relyCraneId bigint;
	DECLARE @srcTaskId bigint;
	DECLARE @count bigint;
	DECLARE @driverId int;
		DECLARE @TaskNo int;
	SELECT @count = count(*) FROM [dbo].[Task_complete]  where wmsTaskId =@wmsTaskId
	if @count<>0 begin
	  return 1--'ok';
	 
	end


	SELECT   @relyComleteId = [Id]  FROM [dbo].[Task_complete]  where wmsTaskId = @relyTaskId
	SELECT  @relyCraneId= [ID]  FROM [dbo].[Task_Crane]  where completeId=@relyComleteId and MotionType=2

	exec @id= [dbo].[_bComplete] @wmsTaskId ,@SrcID,@desID, 3 ,@relyComleteId ,@boxCode,@itemType

	exec @TaskNo = dbo._BBTaskNo  ;
	exec @srcTaskId = dbo._BCrane  @id , @SrcID, 3,1,@boxCode,@TaskNo,@itemType
		exec @TaskNo = dbo._BBTaskNo  ;
	exec  dbo._BCrane  @id , @desID ,3,2 ,@boxCode,@TaskNo,@itemType
	if  @relyCraneId is not null begin
		select @driverId=craneId from dbo.Task_Crane where id = @srcTaskId;
			exec dbo._bCraneRely @id, @srcTaskId,@relyCraneId,'N',@driverId;
	end
	update [dbo].[Task_complete] set status=2 where id=@id--状态设置为计划结束
	return 2--'ok';
END





GO
/****** Object:  StoredProcedure [dbo].[_WCreateOut]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[_WCreateOut](
	@wmstaskid bigint ,
	@SrcID  INT,
	@desID  INT,
	@boxCode varchar(50),
	@itemType int,
	@relyTaskId bigint
	)
AS
BEGIN

	DECLARE @id bigint;
	DECLARE @relyComleteId bigint;
	DECLARE @relyCraneId bigint;
	
	DECLARE @driverId  int;
	DECLARE @srcCraneId bigint;
	DECLARE @desCraneId bigint;
    DECLARE @carrierId bigint;
	DECLARE @cranePlaceLocId bigint;
	DECLARE @carrierBegin bigint;
	DECLARE @count bigint;
	DECLARE @taskNO int;
	SELECT @count = count(*) FROM [dbo].[Task_complete]  where wmsTaskId =@wmsTaskId
	if @count<>0 begin
	   return 1;
	end

	SELECT   @relyComleteId = [Id]  FROM  [dbo].[Task_complete]  where wmsTaskId = @relyTaskId
	SELECT  @relyCraneId= [ID]  FROM  [dbo].[Task_Crane]  where completeId=@relyComleteId and MotionType=2

	exec @id = [dbo].[_bComplete] @wmstaskid ,@SrcID,@desID, 2 ,@relyComleteId ,@boxCode,@itemType

	SELECT @driverId= craneId FROM dbo.physical_Location WHERE id= @SrcID 
	exec @TaskNo = dbo._BBTaskNo  ;
	exec @srcCraneId = dbo._BCrane  @id , @SrcID, 2,1,@boxCode,@TaskNo,@itemType

	exec @TaskNo = dbo._BBTaskNo 
	select @carrierBegin= [dbo]._getOutStockBeginCarrier (@SrcID,@desID) ;

	exec dbo._BCrane  @id ,@carrierBegin ,2,2 ,@boxCode,@taskNO,@itemType
	exec [dbo].[_BCarrier] @id,@boxCode, @carrierBegin,@desID,@TaskNo
	--if @desID>300 begin
		--exec [dbo].[_BMechineHand] @id,@boxCode, @desID,@desID,@TaskNo
	--end
	if  @relyCraneId is not null begin
		exec dbo._bCraneRely @id, @srcCraneId,@relyCraneId,'N',@driverId;
	end
	--exec dbo._bhuman @id, @boxCode,@desID
	update [dbo].[Task_complete] set status=2 where id=@id--状态设置为计划结束
    return 2;
END





GO
/****** Object:  StoredProcedure [dbo].[_WZback]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[_WZback](@id bigint)
	
AS
BEGIN
/**
drop table huax_back.[dbo].[wcs_Task_crane_rely]
drop table huax_back.[dbo].[wcs_Task_Crane]
drop table huax_back.[dbo].[wcs_Task_human]
drop table huax_back.[dbo].[wcs_Task_Carrier]
drop table huax_back.[dbo].[wcs_Task_complete]
	SELECT * into huax_back.[dbo].[wcs_Task_crane_rely] FROM [dbo].[Task_crane_rely]  where 1<>1
	SELECT * into huax_back.[dbo].[wcs_Task_Crane] FROM [dbo].[Task_Crane]  where 1<>1
	SELECT * into huax_back.[dbo].[wcs_Task_human] FROM [dbo].[Task_human]  where 1<>1
	SELECT * into huax_back.[dbo].[wcs_Task_Carrier] FROM [dbo].[Task_Carrier]  where 1<>1
	SELECT * into huax_back.[dbo].[wcs_Task_complete] FROM [dbo].[Task_complete]  where 1<>1
	*/
			
		 
			insert into huax_back.[dbo].[wcs_Task_crane_rely] SELECT *  FROM [dbo].[Task_crane_rely]  where completeId=@id
			delete FROM [dbo].[Task_crane_rely]  where completeId=@id

			insert into huax_back.[dbo].[wcs_Task_Crane] SELECT *  FROM [dbo].[Task_Crane] where completeId=@id
			delete FROM [dbo].[Task_Crane] where completeId=@id

			insert into huax_back.[dbo].wcs_Task_human SELECT *  FROM [dbo].Task_human where completeId=@id
			delete FROM [dbo].Task_human where completeId=@id

			insert into huax_back.[dbo].wcs_Task_Carrier SELECT *  FROM [dbo].Task_Carrier where completeId=@id
			delete FROM [dbo].Task_Carrier where completeId=@id

			insert into huax_back.[dbo].[wcs_Task_complete] SELECT *  FROM [dbo].Task_complete where id=@id
			delete FROM [dbo].[Task_complete] where id=@id
			return 1;
		
END





GO
/****** Object:  StoredProcedure [dbo].[wcsCompleteDelete]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[wcsCompleteDelete]
	(
		@completeId bigint,
		@errMsg varchar(100) out
	)
AS
BEGIN

	DECLARE @status int;
 	BEGIN TRY
		BEGIN TRAN
				exec @status = [dbo].[_WCompleteDelete] @completeId
				set @errMsg='ok'+convert(varchar,@status)
		COMMIT TRAN
	END TRY-----------结束捕捉异常  
	BEGIN CATCH------------有异常被捕获  	
		ROLLBACK TRAN----------回滚事务   
		set @errMsg =  convert(varchar,ERROR_NUMBER())+'-'+convert(varchar,ERROR_SEVERITY())+'-'+convert(varchar,ERROR_STATE())+'-'+ERROR_PROCEDURE()+'的'+ convert(varchar,ERROR_LINE())+'行' +ERROR_MESSAGE(); 
	END CATCH--------结束异常处理  
END









GO
/****** Object:  StoredProcedure [dbo].[wcsCompleteFinish]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[wcsCompleteFinish]
	(
		@completeId bigint,
		@errMsg varchar(100) out
	)
AS
BEGIN

	DECLARE @status int;
	BEGIN TRY
		BEGIN TRAN

				exec @status = [dbo].[_WCompleteFinish] @completeId
					set @errMsg='ok'+convert(varchar,@status)
	 COMMIT TRAN
END TRY-----------结束捕捉异常  
	BEGIN CATCH------------有异常被捕获  	
		ROLLBACK TRAN----------回滚事务   
		set @errMsg =  convert(varchar,ERROR_NUMBER())+'-'+convert(varchar,ERROR_SEVERITY())+'-'+convert(varchar,ERROR_STATE())+'-'+ERROR_PROCEDURE()+'的'+ convert(varchar,ERROR_LINE())+'行' +ERROR_MESSAGE(); 
	
	END CATCH--------结束异常处理  
END









GO
/****** Object:  StoredProcedure [dbo].[wcsCreateIn]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[wcsCreateIn](
	@wmstaskid bigint,
	@srcId int,
	@desId int,
	@boxCode varchar(50),
	@itemType int,--自定义类型，系统根据项目修改 最后一位为表示厚度，倒数第二位代表光纤或者纸库 
	@errMsg varchar(100) out
	)
AS
BEGIN

	DECLARE @status int;
	BEGIN TRY
		BEGIN TRAN
				exec @status = [dbo].[_WCreateIn] @wmstaskid,@srcId,@desId,@boxCode,@itemType
				set @errMsg='ok'+convert(varchar,@status)
	COMMIT TRAN
	END TRY-----------结束捕捉异常  
		BEGIN CATCH------------有异常被捕获  	
			ROLLBACK TRAN----------回滚事务   
			set @errMsg =  convert(varchar,ERROR_NUMBER())+'-'+convert(varchar,ERROR_SEVERITY())+'-'+convert(varchar,ERROR_STATE())+'-'+ERROR_PROCEDURE()+'的'+ convert(varchar,ERROR_LINE())+'行' +ERROR_MESSAGE(); 
	
		END CATCH--------结束异常处理  
END
--UPDATE t1   SET  t1.Status=1  FROM  [sl_wms]. [dbo].[loc_stock] t1  WHERE EXISTS ( SELECT 1 FROM [sl_wms].[dbo].[Task_liku] t2  WHERE t1.ID=t2.stockId AND t2.id=@taskid);
		





GO
/****** Object:  StoredProcedure [dbo].[wcsCreateMove]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[wcsCreateMove](
	@wmsTaskId bigint ,
	@SrcID  INT,
	@desID  INT,
	@boxCode varchar(50),
	@relyTaskId bigint,
	@itemType int,
	@errMsg varchar(100) out
	)
AS
BEGIN
	DECLARE @status int;
	BEGIN TRY
		BEGIN TRAN
		exec @status = [dbo].[_WCreateMove] @wmsTaskId,@SrcID,@desID,@boxCode,@relyTaskId,@itemType
		set @errMsg='ok'+convert(varchar,@status)
COMMIT TRAN
END TRY-----------结束捕捉异常  
	BEGIN CATCH------------有异常被捕获  	
		ROLLBACK TRAN----------回滚事务   
		set @errMsg =  convert(varchar,ERROR_NUMBER())+'-'+convert(varchar,ERROR_SEVERITY())+'-'+convert(varchar,ERROR_STATE())+'-'+ERROR_PROCEDURE()+'的'+ convert(varchar,ERROR_LINE())+'行' +ERROR_MESSAGE(); 
	
	END CATCH--------结束异常处理  
END





GO
/****** Object:  StoredProcedure [dbo].[wcsCreateOut]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[wcsCreateOut](
	@wmstaskid bigint ,
	@SrcID  INT,
	@desID  INT,
	@boxCode varchar(50),
	@itemType int,--倒数第三位 1，配纤出库，2订单出库
	@relyTaskId bigint,
	@errMsg varchar(100) out
	)
AS
BEGIN
	DECLARE @status int;
	BEGIN TRY
		BEGIN TRAN
			exec @status = [dbo].[_WCreateOut] @wmstaskid,@SrcID,@desID,@boxCode,@itemType,@relyTaskId
		set @errMsg='ok'+convert(varchar,@status)
COMMIT TRAN
END TRY-----------结束捕捉异常  
	BEGIN CATCH------------有异常被捕获  	
		ROLLBACK TRAN----------回滚事务   
		set @errMsg =  convert(varchar,ERROR_NUMBER())+'-'+convert(varchar,ERROR_SEVERITY())+'-'+convert(varchar,ERROR_STATE())+'-'+ERROR_PROCEDURE()+'的'+ convert(varchar,ERROR_LINE())+'行' +ERROR_MESSAGE(); 
	
	END CATCH--------结束异常处理  
END





GO
/****** Object:  StoredProcedure [dbo].[wcsTaskNo]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[wcsTaskNo](
	@seek int out,
	@errMsg varchar(100) out
	)
AS
BEGIN


	BEGIN TRY
		BEGIN TRAN
				exec @seek = [dbo].[_BBTaskNo]
				set @errMsg='ok'
	COMMIT TRAN
	END TRY-----------结束捕捉异常  
		BEGIN CATCH------------有异常被捕获  	
			ROLLBACK TRAN----------回滚事务   
			set @errMsg =  convert(varchar,ERROR_NUMBER())+'-'+convert(varchar,ERROR_SEVERITY())+'-'+convert(varchar,ERROR_STATE())+'-'+ERROR_PROCEDURE()+'的'+ convert(varchar,ERROR_LINE())+'行' +ERROR_MESSAGE(); 
	
		END CATCH--------结束异常处理  
END
--UPDATE t1   SET  t1.Status=1  FROM  [sl_wms]. [dbo].[loc_stock] t1  WHERE EXISTS ( SELECT 1 FROM [sl_wms].[dbo].[Task_liku] t2  WHERE t1.ID=t2.stockId AND t2.id=@taskid);
		





GO
/****** Object:  StoredProcedure [dbo].[wcsZback]    Script Date: 2020/1/16 15:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[wcsZback](@info varchar(100) out)
	
AS
BEGIN

    DECLARE @craneId bigint;
    DECLARE @rgvId bigint;
    DECLARE @id bigint;
	DECLARE @status int;

	DECLARE @wmdTaskId bigint;
	SELECT  top(1)  @id=ID ,@wmdTaskId = t.wmsTaskId FROM  [dbo].Task_complete t  where ( status=3 or status=-1) and t.upload=1  and  DATEDIFF(SS,t.endTime,GETDATE())>0   order by ID 
	IF @id=0 or @id is null
	BEGIN
		SET @info=''
			return
	END
	
	BEGIN TRY---------------------开始捕捉异常  
		--开启事务
		BEGIN TRAN
			exec @status=dbo._WZback @id
			SET @info='z_back'+convert(varchar(100),@id)
		
		COMMIT TRAN
	END TRY
	BEGIN CATCH
			ROLLBACK TRAN
		set @info =  convert(varchar,ERROR_NUMBER())+'-'+convert(varchar,ERROR_SEVERITY())+'-'+convert(varchar,ERROR_STATE())+'-'+ERROR_PROCEDURE()+'的'+ convert(varchar,ERROR_LINE())+'行' +ERROR_MESSAGE(); 
	
	END CATCH

END







GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'第几个货位，双伸或多伸时使用' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'physical_Location', @level2type=N'COLUMN',@level2name=N'deep'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1；入库，2出库，3 移库' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Task_complete', @level2type=N'COLUMN',@level2name=N'type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1生成初始化阶段，2计划执行中，3执行完成,可以在本表内删除' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Task_complete', @level2type=N'COLUMN',@level2name=N'status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'原始位置编号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Task_Crane', @level2type=N'COLUMN',@level2name=N'locId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'执行优先级，暂定1-10，1最高。' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Task_Crane', @level2type=N'COLUMN',@level2name=N'Priority'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1:入库；2：出库；3：移库；4：半自动' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Task_Crane', @level2type=N'COLUMN',@level2name=N'MotionType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'附加信息' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Task_Crane', @level2type=N'COLUMN',@level2name=N'Extra'
GO
USE [master]
GO
ALTER DATABASE [huax_wcs] SET  READ_WRITE 
GO
