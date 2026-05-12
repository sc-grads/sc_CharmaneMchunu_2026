USE [AdventureWorks2022]
GO

/****** Object:  Table [Sales].[storenew]    Script Date: 2026/05/11 12:16:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Sales].[storenew](
	[store_id] [int] NOT NULL,
	[sales] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[store_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


