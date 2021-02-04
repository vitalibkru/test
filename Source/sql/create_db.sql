USE [master]
GO

CREATE DATABASE [%dbname%] ON  PRIMARY
( NAME = N'%dbname%', FILENAME = N'%dbpath%\%dbname%.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON
( NAME = N'%dbname%_log', FILENAME = N'%dbpath%\%dbname%_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [%dbname%].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [%dbname%] SET ANSI_NULL_DEFAULT OFF
GO

ALTER DATABASE [%dbname%] SET ANSI_NULLS OFF
GO

ALTER DATABASE [%dbname%] SET ANSI_PADDING OFF
GO

ALTER DATABASE [%dbname%] SET ANSI_WARNINGS OFF
GO

ALTER DATABASE [%dbname%] SET ARITHABORT OFF
GO

ALTER DATABASE [%dbname%] SET AUTO_CLOSE OFF
GO

ALTER DATABASE [%dbname%] SET AUTO_SHRINK OFF
GO

ALTER DATABASE [%dbname%] SET AUTO_UPDATE_STATISTICS ON
GO

ALTER DATABASE [%dbname%] SET CURSOR_CLOSE_ON_COMMIT OFF
GO

ALTER DATABASE [%dbname%] SET CURSOR_DEFAULT  GLOBAL
GO

ALTER DATABASE [%dbname%] SET CONCAT_NULL_YIELDS_NULL OFF
GO

ALTER DATABASE [%dbname%] SET NUMERIC_ROUNDABORT OFF
GO

ALTER DATABASE [%dbname%] SET QUOTED_IDENTIFIER OFF
GO

ALTER DATABASE [%dbname%] SET RECURSIVE_TRIGGERS OFF
GO

ALTER DATABASE [%dbname%] SET  DISABLE_BROKER
GO

ALTER DATABASE [%dbname%] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO

ALTER DATABASE [%dbname%] SET DATE_CORRELATION_OPTIMIZATION OFF
GO

ALTER DATABASE [%dbname%] SET TRUSTWORTHY OFF
GO

ALTER DATABASE [%dbname%] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO

ALTER DATABASE [%dbname%] SET PARAMETERIZATION SIMPLE
GO

ALTER DATABASE [%dbname%] SET READ_COMMITTED_SNAPSHOT OFF
GO

ALTER DATABASE [%dbname%] SET HONOR_BROKER_PRIORITY OFF
GO

ALTER DATABASE [%dbname%] SET RECOVERY SIMPLE
GO

ALTER DATABASE [%dbname%] SET  MULTI_USER
GO

ALTER DATABASE [%dbname%] SET PAGE_VERIFY CHECKSUM
GO

ALTER DATABASE [%dbname%] SET DB_CHAINING OFF
GO

ALTER DATABASE [%dbname%] SET  READ_WRITE
GO


