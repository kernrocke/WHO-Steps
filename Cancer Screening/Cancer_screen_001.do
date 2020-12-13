

clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Cancer_screen_001.do
**  Project:      	WHO STEPS 
**	Sub-Project:	Regional Active Commuting WHO STEPS
**  Analyst:		Kern Rocke
**	Date Created:	11/12/2020
**	Date Modified: 	12/12/2020
**  Algorithm Task: Cancer Screening Across Caribbean countries using WHO STEPS

*Country analaysis

** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 150


*Setting working directory

*-------------------------------------------------------------------------------
** Dataset to encrypted location

*WINDOWS OS
*local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*WINDOWS OS (Alternative)
*local datapath "X:/The UWI - Cave Hill Campus/DataGroup - repo_data/data_p145"

*MAC OS
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

** Logfiles to unencrypted location

*WINDOWS OS
*local logpath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*WINDOWS OS (Alternative)
*local logpath "X:/The UWI - Cave Hill Campus/DataGroup - repo_data/data_p145"

*MAC OS
*local logpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

**Aggregated output path

*WINDOWS OS
*local outputpath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*WINDOWS OS (Alternative)
*local outputpath "X:/The UWI - Cave Hill Campus/DataGroup - PROJECT_p145"

*MAC OS
local outputpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

*Open log file to store results
*log using "`logpath'/version01/3-output/WHO STEPS/cancer_screeb_001.log",  replace

*-------------------------------------------------------------------------------


*-------------------------------------------------------
*-------------------------------------------------------

*Load in data from encrypted location

*BAHAMAS
use "`datapath'/version01/1-input/WHO STEPS/bhs2011.dta", clear

*Create country variable
gen country = 1

*Save dataset
save "`datapath'/version01/2-working/WHO STEPS/Bahamas_2011.dta", replace

*-------------------------------------------------------

*BARBADOS
use "`datapath'/version01/1-input/WHO STEPS/brb2007.dta", clear

*Create country variable
gen country = 2

*Save dataset
save "`datapath'/version01/2-working/WHO STEPS/Barbados_2007.dta", replace

*-------------------------------------------------------

*BRITISH VIRGIN ISLANDS
use "`datapath'/version01/1-input/WHO STEPS/BVI2009.dta", clear

*Create country variable
gen country = 3

*Save dataset
save "`datapath'/version01/2-working/WHO STEPS/BVI_2009.dta", replace

*---------------------------------------------------------

*CAYMAN ISLANDS
use "`datapath'/version01/1-input/WHO STEPS/CYM2012.dta", clear

*Create country variable
gen country = 4

*Save dataset
save "`datapath'/version01/2-working/WHO STEPS/Cayman_2012.dta", replace

*------------------------------------------------------------

*Grenada
use "`datapath'/version01/1-input/WHO STEPS/GRD2010.dta", clear

*Create country variable
gen country = 5

*Save dataset
save "`datapath'/version01/2-working/WHO STEPS/Grenada_2010.dta", replace

*-------------------------------------------------------------

*Guyana
use "`datapath'/version01/1-input/WHO STEPS/guy2016.dta", clear

*Create country variable
gen country = 6

*Save dataset
save "`datapath'/version01/2-working/WHO STEPS/Guyana_2016.dta", replace

*-------------------------------------------------------------

clear

*Comine datasets
use "`datapath'/version01/2-working/WHO STEPS/Bahamas_2011.dta", clear
append using "`datapath'/version01/2-working/WHO STEPS/Barbados_2007.dta", force
append using "`datapath'/version01/2-working/WHO STEPS/BVI_2009.dta", force
append using "`datapath'/version01/2-working/WHO STEPS/Cayman_2012.dta", force
append using "`datapath'/version01/2-working/WHO STEPS/Grenada_2010.dta", force
append using "`datapath'/version01/2-working/WHO STEPS/Guyana_2016.dta", force

*Analysis on person >= 40 years
keep if age >= 40

*Label country variable
label var country "Country"
label define country 1"Bahamas" 2"Barbados" 3"British Virgin Islands" ///
					 4"Cayman Islands" 5"Grenada" 6"Guyana"
label value country country

*Code sex variable
encode sex, gen(gender)

*CRC Screening (Colonoscopy & Test for Blood in stool)
gen crc_screen = .
replace crc_screen = 1 if r2 == 1 | r3 == 1
replace crc_screen = 1 if s1 == 1 | s2 == 1
replace crc_screen = 0 if r2 == 2 & r3 == 2
replace crc_screen = 0 if s1 == 2 | s2 == 2
replace crc_screen = 0 if r2 == 2 & r3 == 9
replace crc_screen = 0 if s1 == 2 | s2 == 9
replace crc_screen = 0 if r2 == 9 & r3 == 2
replace crc_screen = 0 if s1 == 9 | s2 == 2
replace crc_screen = 0 if r2 == 9 & r3 == 9
replace crc_screen = 0 if s1 == 9 | s2 == 9
label var crc_screen "Colorectal Cancer Screening"
label define crc_screen 0"No CRC screen" 1"CRC Screened"
label value crc_screen crc_screen

*Prostate Cancer screening (Prostate exam)
gen prostate = .
replace prostate = 1 if r1 == 1 | s3 == 1
replace prostate = 0 if r1 == 2 | r1 == 9 | s3 == 2
label var prostate "Prostate Cancer Screening"
label define prostate 0"No Prostate exam" 1"Prostate Exam"
label value prostate prostate

*Breast Cancer screening (Mamogram)
gen breast = .
// mamogram
replace breast = 1 if w4 == 1 | w4 == 2 | w4 == 3 | s6 == 1 | s6 == 2 | s6 == 3 
replace breast = 0 if w4 == 4 | w4 == 7 | w4 == 9 | s6 == 77 | s6 == 4
label var breast "Breast Cancer Screening"
label define breast 0"No Breast exam" 1"Breast Exam"
label value breast breast

*Cervical Cancer screeing (Pap smear)
gen cervical = . 
replace cervical = 1 if s7 == 1 | s7 == 2 | s7 == 3 | w7 == 1 | w7 == 2 | w7 == 3
replace cervical = 0 if s7 == 4 | s7 == 77 | w7 == 7 | w7 == 9 | w7 == 4
label var cervical "Cervical Cancer Screening"
label define cervical 0"No pap smear" 1"Pap smear"
label value cervical cervical

proportion crc_screen, over(country) // both male and female
proportion prostate if gender == 1, over(country) // male
proportion breast if gender == 2, over(country) // female
proportion cervical if gender == 2, over(country) // female

*Convert proportions to percentages
replace crc_screen = crc_screen * 100
replace prostate = prostate * 100
replace breast = breast * 100
replace cervical = cervical * 100


*Create clustered Bar chart of Breast, Prostate and Colorectal cancer screening

#delimit;

	graph hbar (mean) breast prostate crc_screen cervical
	
	, 
	
	 over(country, relabel(1"Bahamas"
						   2"Barbados"
						   3"BVI"
						   4"Cayman Islands"
						   5"Grenada"
						   6"Guyana"))
	
	 plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
     graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
     bgcolor(white) 
	 
	 bar(1, bc(pink*0.65) blw(vthin) blc(gs0))
	 bar(2, bc(blue*0.65) blw(vthin) blc(gs0))
	 bar(3, bc(green*0.65) blw(vthin) blc(gs0))
	 bar(4, bc(orange*0.65) blw(vthin) blc(gs0))
	 
	 blabel(bar, format(%9.0f) pos(outside) size(small))
	 
	 ylab(, nogrid )
	 ytitle("Percentage (%)", margin(t=0.5) size(medium)) 
	 
	 legend(size(medium)  cols(2)
				region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2)) 
				order(1 2 3 4)
				lab(1 "Breast")
				lab(2 "Prostate")
				lab(3 "CRC")
				lab(4 "Cervical")
				)
	 
	;
#delimit cr
