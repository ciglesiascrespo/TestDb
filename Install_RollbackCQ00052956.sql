/*#########################################################################################################
# NOMBRE:              Install_RollbackCQ00052956.sql
# OBJETIVO:            Ejecutar el rollback 
# LIDER TECNICO:       BanRep (G. Sarmiento)
# FECHA:               20191009
# REALIZADO POR:       TERADATA
#    
#    Historial de Modificaciones
# -----------------------------------------------------------------------------------------
#  Autor                 Fecha        Descripcion
#------------------------------------------------------------------------------------------
# TDC Paola Ortega    2019-12-01   Ejecutar el rollback 
###########################################################################################################
*/ 


.SET DEFAULTS
.SET TITLEDASHES OFF
.SET WIDTH 20000
SEL DATE,TIME;



/* ###########################################
        Restaurar el  SP
###########################################*/


select 1 from dbc.TablesV 
where databasename = 'PRU_BR_DATA' 
and TableName = 'Sp_SIGTBEFAprobacionRechazo'
AND tablekind='P';

.if activitycount = 0 then GoTo ok
DROP PROCEDURE PRU_BR_DATA.Sp_SIGTBEFAprobacionRechazo;
.IF ERRORCODE <> 0 THEN .GOTO ERRORFOUND
.label ok


select 1 from dbc.TablesV 
where databasename = 'PRU_BR_DATA' 
and TableName = 'Sp_SIGTBEFAprobacionRechazo_BKCQ00052956'
and TableKind = 'P';

.if activitycount = 0 then GoTo ok2
RENAME PROCEDURE PRU_BR_DATA.Sp_SIGTBEFAprobacionRechazo_BKCQ00052956 TO PRU_BR_DATA.Sp_SIGTBEFAprobacionRechazo;
.label ok2
.IF ERRORCODE <> 0 THEN GOTO ERRORFOUND

/* ###########################################
        Eliminacion del  SP
###########################################*/


select 1 from dbc.TablesV 
where databasename = 'PRU_BR_DATA' 
and TableName = 'Sp_SIGTBaEnFiPrerrequisito'
AND tablekind='P';

.if activitycount = 0 then GoTo ok3
DROP PROCEDURE PRU_BR_DATA.Sp_SIGTBaEnFiPrerrequisito;
.IF ERRORCODE <> 0 THEN .GOTO ERRORFOUND
.label ok3

/*##########################################
-- 			Borra Tipo Parametro
############################################*/

DELETE FROM PRU_BR_DATA.SIGT_TipoParametro WHERE Id_TipoParametro = '65';
.IF ERRORCODE <> 0 THEN .GOTO ERRORFOUND
DELETE FROM PRU_BR_DATA.SIGT_TipoParametro WHERE Id_TipoParametro = '66';
.IF ERRORCODE <> 0 THEN .GOTO ERRORFOUND
DELETE FROM PRU_BR_DATA.TP_Parametros WHERE NombreParametro = 'v_GTBaEnFiBDOrigen';
.IF ERRORCODE <> 0 THEN .GOTO ERRORFOUND

/* ###########################################
         Eliminar tablas STAGE
###########################################*/

select 1 from dbc.TablesV 
where databasename = 'PRU_BR_STAGE' 
and TableName = 'GTBaEnFi'
and tablekind='T';

.if activitycount = 0 then GoTo ok
DROP TABLE PRU_BR_STAGE.GTBaEnFi;

.IF ERRORCODE <> 0 THEN .GOTO ERRORFOUND
.label ok

.GOTO FINOK

.LABEL ERRORFOUND
.REMARK '#### ERROR INESPERADO'
.EXIT ERRORCODE

.LABEL FINOK
.REMARK '#### EJECUCION EXITOSA '
.LOGOFF;
.QUIT 0;
