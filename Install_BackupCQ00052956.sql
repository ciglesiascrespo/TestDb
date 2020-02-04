/*#########################################################################################################
# NOMBRE:            Install_BackupCQ00052956.sql
# OBJETIVO:          Creación Backup  para GT
# LIDER TECNICO:     BanRep (G. Sarmiento)
# FECHA:             20191202
# REALIZADO POR:     TERADATA
#    
# Historial de Modificaciones
# -----------------------------------------------------------------------------------------
#  Autor                       Fecha            Descripcion
# ------------------------------------------------------------------------------------------
# TDC Paola Ortega        2019-12-12     Creación Backup 
# #########################################################################################################*/

.SET DEFAULTS
.SET TITLEDASHES OFF
.SET WIDTH 20000
SEL DATE,TIME;


/* ###########################################
       Backup Sp
###########################################*/

SELECT 1 FROM dbc.TablesV 
WHERE databasename = 'PRU_BR_DATA' 
AND TABLENAME = 'Sp_SIGTBEFAprobacionRechazo_BKCQ00052956'
AND TableKind = 'P';


.IF ACTIVITYCOUNT = 0 THEN GOTO ok2
DROP PROCEDURE PRU_BR_DATA.Sp_SIGTBEFAprobacionRechazo_BKCQ00052956;
.IF ERRORCODE <> 0 THEN GOTO ERRORFOUND
.LABEL ok2


SELECT 1 FROM dbc.TablesV 
WHERE databasename = 'PRU_BR_DATA' 
AND TABLENAME = 'Sp_SIGTBEFAprobacionRechazo'
AND TableKind = 'P';


.IF ACTIVITYCOUNT = 0 THEN GOTO ok3
RENAME PROCEDURE PRU_BR_DATA.Sp_SIGTBEFAprobacionRechazo TO PRU_BR_DATA.Sp_SIGTBEFAprobacionRechazo_BKCQ00052956;
.IF ERRORCODE <> 0 THEN GOTO ERRORFOUND
.LABEL ok3



.GOTO FINOK

.LABEL ERRORFOUND
.REMARK '#### ERROR INESPERADO'
.EXIT ERRORCODE

.LABEL FINOK
.REMARK '#### EJECUCION EXITOSA '
.LOGOFF;
.QUIT 0;



