
# "strandr: Insektlokaliteter i R"
Jon Peder Lindemann
26 Februar 2021



## Innledning

Strand-systemet er en inndeling av Norge i 37 biogeografiske regioner basert på norske fylkesgrenser anno 1978 (Strand 1943, Økland 1981, Endrestøl 2021). Systemet har lenge vært populært blant entomologer i Norge, og ble i sin tid anbefalt av Norsk Entomologisk Forening. Etter flere runder med kommune og fylkesendringer har de gamle fylkesgrensene gradvis forandret seg, og det har i noen tilfeller blitt vanskelig å finne frem til riktige strand-regioner (strand-koder). Målet med 'strandr' er å gjøre denne jobben enklere. 

Funksjonen returnerer strand-koder og lokalitetsnavn fra en, eller et sett av desimalgrader. Strand-kodene identifiseres ved å finne krysningspunkt av koordinat over et polygon-lag av strand-regioner. Polygon-laget er laget av Anders Endrestøl (NINA) og baserer seg på kommunegrenser fra  1986 (Endrestøl 2021). Norske stedsnavn lastes ned fra Sentralt Stednavnregister (SSR) via deres API. For hvert koordinat blir det nærmeste stedsnavnet i SSR returnert.


## Eksempel

### Installer 'strandr'
```{r, eval = FALSE}
require(devtools) # Bruk 'devtols' for å laste ned fra github
install_github("jonpeder/strandr")
```


### Importer tabell
Importer tabell med koordinater, for eksempel fra en tab-separert tekstfil. Koordinatene må være desimalgrader (Projeksjon: longlat, Datum: WGS84). Tabellen kan gjerne inneholde annen innsamlingsdata, for eksempel event-ID, habitat, metode, etc. Siden SSR ikke returnerer noe navn mellom kommune og stedsnavn, kan det lønne seg å ha med et overordnet stedsnavn, for eksempel Kvaløya i Tromsø, Maridalen i Oslo, eller Søm i Grimstad.  

```{r}
eks_inn <- read.table("koordinater.txt", sep = "\t", header = TRUE) # Les inn tabellen 
eks_inn # Sjekk ut tabellen
```


### Hent strandkoder og lokalitetsnavn
I tillegg til strand-kode (strand) og stedsnavn (locality), returneres fylke (county), kommune (municipality), steds-type (type), avstand fra punkt til punktet for stedsnavnet (dist_m), orientering fra steds-punkt mot koordinat-punkt (orient).

```{r}
library(strandr) # Last inn 'strandr'

# Legg tabell inn i funksjonen og spesifiser parametrene lengdegrad (lon) og breddegrad (lat)
eks_ut <- strandr(eks_inn, lon = eks_inn$longitude, lat = eks_inn$latitude) 

eks_ut # Sjekk ut den nye tabellen
```

### Eksporter resultat
```{r}
write.table(eks_ut, "eks_ut.txt", sep = "\t", row.names = FALSE, quote = FALSE)
```

### Bare strand-koder
```{r}
bare_str <- strandkoder(eks_inn$latitude, eks_inn$longitude)
bare_str
```


## Referanser
Endrestøl, A. 2021. Strand-systemet 4.0. Insektnytt 46 (1): 43-72.  
Strand, A. 1943. Inndelingen av Norge til bruk ved faunistiske oppgaver. Norsk  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Entomologisk Tidskrift, 6 (4-5):208-224.  
Økland, K.A. 1981. Inndeling av Norge til bruk ved biogeografiske oppgaver - et  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;revidert Strandsystem. Fauna 34: 167 - 178.
