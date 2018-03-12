IF EXISTS (SELECT 1 FROM sys.procedures sp WHERE schema_name(sp.schema_id) = 'pies' AND name = 'GetPiesHierarchyNodes')
	DROP PROCEDURE  pies.GetPiesHierarchyNodes
GO

/***************************************************************************
* Procedure   :   pies.GetPiesHierarchyNodes
* Description :   Returns the PIES hierarchy for a sales organistation
*                  
* Param/Arg				IN/OUT  Description
* -----------			------  ------------------------------------------
* salesOrgID			IN		
* hierarchyId			IN
* hierarchyNode			IN
* pageNumber			IN		
* pageSize				IN		
*
* Changelog	
* When			Who		Why
* 18/11/2016    Carol   720 - Return PIES article hierarchy
* 16/12/2016	Carol	Change node parameter length
***************************************************************************/
CREATE PROCEDURE [pies].[GetPiesHierarchyNodes]
(
	@salesOrgId	INT,
	@hierarchyId INT,
	@hierarchyNode VARCHAR(255) = NULL,
	@pageNumber INT,
	@pageSize INT
)
AS
BEGIN
	SET NOCOUNT ON

	CREATE TABLE #hn
	(
		HierarchyLevel INTEGER,
		HierarchyNode VARCHAR(255),
		[Description] VARCHAR(50),
		ParentNode VARCHAR(255)
	)

	-- insert hierarchy into temp table for speed
	SELECT	[ArticleHierarchyId],
			[HierarchyNode],
			[NodeDescription],
			[ParentHierarchyNode]
	INTO	#nodes
	FROM	pies.ArticleHierarchyNode ahn
	WHERE	ahn.ArticleHierarchyId = @hierarchyId
	AND		ahn.IsActive = 1

	-- get the hierarchy
	;WITH HierarchyNode AS
	(
		SELECT	1 AS HierarchyLevel,
				ah.HierarchyNode,
				ah.NodeDescription [Description],
				ah.ParentHierarchyNode [ParentNode]
		FROM	#nodes ah
		WHERE	ah.ParentHierarchyNode IS NULL
		UNION ALL
		SELECT	hn.HierarchyLevel + 1 AS HierarchyLevel,
				ahn.HierarchyNode,
				ahn.NodeDescription [Description],
				ahn.ParentHierarchyNode [ParentNode]
		FROM	#nodes ahn
		INNER JOIN HierarchyNode hn
		ON		hn.HierarchyNode = ahn.ParentHierarchyNode
		WHERE	ahn.ParentHierarchyNode IS NOT NULL
	)
	INSERT INTO #hn
	SELECT	HierarchyLevel,
			HierarchyNode,
			[Description],
			ParentNode
	FROM	HierarchyNode
	OPTION(MAXRECURSION 32767)

	IF @hierarchyNode IS NOT NULL
	BEGIN
		;WITH HierarchyNodeSupplied AS
		(
			SELECT	parent.HierarchyLevel,
					parent.HierarchyNode,
					parent.[Description],
					parent.ParentNode
			FROM	#hn parent
			WHERE	parent.HierarchyNode = @hierarchyNode
			UNION ALL
			SELECT	child.HierarchyLevel,
					child.HierarchyNode,
					child.[Description],
					child.ParentNode
			FROM	#hn child
			INNER JOIN HierarchyNodeSupplied parent
			ON		parent.HierarchyNode = child.ParentNode
		)
		SELECT	HierarchyLevel,
				HierarchyNode,
				[Description],
				ParentNode
		INTO #hNode
		FROM	HierarchyNodeSupplied
		OPTION(MAXRECURSION 32767)

		SELECT	HierarchyLevel,
				HierarchyNode,
				[Description],
				ParentNode
		FROM	#hNode
		ORDER BY
				HierarchyLevel,
				HierarchyNode 
		OFFSET @pageSize * (@pageNumber -1) ROWS
		FETCH NEXT @pageSize ROWS ONLY OPTION (RECOMPILE)

		DROP TABLE #hNode
	END
	ELSE
	BEGIN
		SELECT	HierarchyLevel,
				HierarchyNode,
				[Description],
				ParentNode
		FROM	#hn
		ORDER BY	HierarchyLevel,
					HierarchyNode 
		OFFSET @pageSize * (@pageNumber -1) ROWS
		FETCH NEXT @pageSize ROWS ONLY OPTION (RECOMPILE)
	END
	DROP TABLE #hn, #nodes
	SET NOCOUNT OFF
END