SELECT	@SELECT:DIM:USER_DEF:IMPLIED:PROJECT:projects.id:id@,
	@SELECT:DIM_PROP:USER_DEF:IMPLIED:PROJECT:projects.name:name@,
        @SELECT:DIM_PROP:USER_DEF:IMPLIED:PROJECT:projects.code:code@,
	@SELECT:DIM_PROP:USER_DEF:IMPLIED:PROJECT:projects.percent_complete:percent_complete@,
        @SELECT:DIM_PROP:USER_DEF:IMPLIED:PROJECT:projects.calculation:calculation@,
        @SELECT:DIM_PROP:USER_DEF:IMPLIED:PROJECT:projects.description:description@
FROM	(
	SELECT DISTINCT 
		inv.id,
		inv.name,
		inv.code,
		prj.percent_complete,
		'% Complete = Total Level 1 Tasks Days Complete / Total Level 1 Tasks Duration' calculation,
		'Clarity calculates Project % Complete automatically' description
	FROM        inv_projects prj
		JOIN    odf_ca_project odf_prj  ON prj.prid = odf_prj.id
		JOIN    inv_investments inv     ON prj.prid = inv.id
		JOIN    prtask tsk              ON prj.prid = tsk.prprojectid
		JOIN    odf_ca_task odf_tsk     ON tsk.prid = odf_tsk.id
	WHERE       	prj.is_template = 0 
		AND     inv.odf_object_code = 'project' 
		AND     inv.is_active = 1
		AND     (prj.percent_calc_mode = 0 AND odf_prj.cpc_calc_method = 'DURATION')
		AND     tsk.pristask = 1
	) projects
WHERE	@FILTER@
HAVING	@HAVING_FILTER@
