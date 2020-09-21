USE [esklad]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID (N'dbo.date2int', N'FN') IS NOT NULL  
    DROP FUNCTION dbo.date2int;  
GO 

CREATE FUNCTION [dbo].[date2int]
(
	@Date datetime
)
RETURNS bigint
AS
BEGIN
	RETURN ROUND(convert(float, ISNULL(@Date,0),0),0,1)+2;
END
GO

IF OBJECT_ID (N'dbo.time2int', N'FN') IS NOT NULL  
    DROP FUNCTION dbo.time2int;  
GO 

CREATE FUNCTION [dbo].[time2int]
(
	@Date datetime
)
RETURNS bigint
AS
BEGIN
	DECLARE @RET float = convert(float, ISNULL(@Date,0),0);
	SET @RET = @RET - round(@RET, 0, 1)

	RETURN round(86400*@RET, 0, 1);
END
GO

IF OBJECT_ID (N'dbo.dateOver', N'FN') IS NOT NULL  
    DROP FUNCTION dbo.dateOver;  
GO 

CREATE FUNCTION [dbo].[dateOver]
(
	@Value bigint
	, @Date datetime
)
RETURNS bit
AS
BEGIN
	DECLARE @RET bit = 0;

	IF (@Value=0) 
		SET @RET = 1;
	
	ELSE IF (@Value >= dbo.date2int(@Date))
		SET @RET = 1;
	
	RETURN @RET;

END
GO

IF OBJECT_ID (N'dbo.datetimeOver', N'FN') IS NOT NULL  
    DROP FUNCTION dbo.datetimeOver;  
GO 

CREATE FUNCTION [dbo].[datetimeOver]
(
	@VDate bigint
	,@VTime bigint
	,@Date datetime
)
RETURNS bit
AS
BEGIN
  DECLARE @RET bit = 0;
  DECLARE @DD bigint = dbo.date2int(@Date);

  IF (@VDate=0)
    SET @RET = 1;
  ELSE IF (@VDate > @DD)
    SET @RET = 1;
  ELSE IF (@VDate = @DD)
    IF (@VTime=0)
      SET @RET = 1;
    ELSE IF (@VTime >= dbo.time2int(@Date))
      SET @RET = 1;

	RETURN @RET;
END
GO

