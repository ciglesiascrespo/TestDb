/*#########################################################################################################
# NOMBRE:              Install_POS_CQ00052956.sql
# OBJETIVO:            Ejecutar el despliegue
# LIDER TECNICO:       BanRep (G. Sarmiento)
# FECHA:               20191202
# REALIZADO POR:       TERADATA
#    
#    Historial de Modificaciones
# ---------------------------------------------------------------------------------------------------------
#  Autor                 				Fecha        Descripcion
# ---------------------------------------------------------------------------------------------------------
# TDC Paola Ortega       2019-12-02   Ejecutar el despliegue 
###########################################################################################################
*/ 

.SET DEFAULTS
.SET TITLEDASHES OFF
.SET WIDTH 254
SEL DATE,TIME;


/*##########################################
-- 			Crea Procedimiento Sp_SIGTBEFAprobacionRechazo
############################################*/

SELECT 1 FROM dbc.TablesV 
WHERE databasename = 'PRU_BR_DATA' 
AND TableName = 'Sp_SIGTBEFAprobacionRechazo'
AND TableKind = 'P';

.if activitycount = 0 then GoTo ok6
DROP PROCEDURE PRU_BR_DATA.Sp_SIGTBEFAprobacionRechazo;
.IF ERRORCODE <> 0 THEN .GOTO ERRORFOUND

.label ok6

.compile file Model/Procedures/Sp_SIGTBEFAprobacionRechazo.sql
.IF ERRORCODE <> 0 THEN .GOTO ERRORFOUND

/*##########################################
-- 			Crea Procedimiento Sp_SIGTBaEnFiPrerrequisito
############################################*/

SELECT 1 FROM dbc.TablesV 
WHERE databasename = 'PRU_BR_DATA' 
AND TableName = 'Sp_SIGTBaEnFiPrerrequisito'
AND TableKind = 'P';

.if activitycount = 0 then GoTo ok7
DROP PROCEDURE PRU_BR_DATA.Sp_SIGTBaEnFiPrerrequisito;
.IF ERRORCODE <> 0 THEN .GOTO ERRORFOUND

.label ok7

.compile file Model/Procedures/Sp_SIGTBaEnFiPrerrequisito.sql
.IF ERRORCODE <> 0 THEN .GOTO ERRORFOUND

/* ###########################################
        Script Tipo Parametro
###########################################*/

.run file Model/Scripts/Script_CQ00052956.sql
.IF ERRORCODE <> 0 THEN .GOTO ERRORFOUND

/* ###########################################
         GRANT a los objetos del Modelo
###########################################*/

.run file Model/Grants/GRANT_SIGT_CQ00052956.sql
.IF ERRORCODE <> 0 THEN .GOTO ERRORFOUND

.GOTO FINOK

.LABEL ERRORFOUND
.REMARK '#### ERROR INESPERADO'
.EXIT ERRORCODE

.LABEL FINOK
.REMARK '#### EJECUCI�N EXITOSA '
.LOGOFF;
.QUIT 0;