USE [AdventureWorks2022]
GO

/****** Object:  Table [dbo].[Sales]    Script Date: 2026/05/11 12:16:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Sales](
	[EmpID] [int] NULL,
	[EmpName] [nvarchar](50) NULL,
	[SalesNumber] [int] NOT NULL,
	[ItemSold] [int] NULL,
 CONSTRAINT [PK_Sales] PRIMARY KEY CLUSTERED 
(
	[SalesNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


