USE [AdventureWorks2022]
GO

/****** Object:  Table [Sales].[visits]    Script Date: 2026/05/11 12:14:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Sales].[visits](
	[visit_id] [int] IDENTITY(1,1) NOT NULL,
	[first_name] [varchar](50) NOT NULL,
	[last_name] [varchar](50) NOT NULL,
	[visited_at] [datetime] NULL,
	[phone] [varchar](20) NULL,
	[store_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[visit_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Sales].[visits]  WITH CHECK ADD FOREIGN KEY([store_id])
REFERENCES [Sales].[storenew] ([store_id])
GO


