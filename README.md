# strandr
Obtain insect locality data, including Strand-codes, from coordinates (within Norway) 

## Introduksjon til 'strandr': Generer lokalitetsdata, inkludert Strand-koder, fra koordinater.

Strand-systemet er en inndeling av Norge i 37 geografiske regioner basert på norges tidligere fylker (se Strand 1943, Økland 1981). Strand-systemet er populært blant entomologer i Norge, og annbefalt av Norsk Entomologisk Forening som faunistisk data. Ettersom systemet er basert på gamle kommunegrenser har det etter hvert blitt vanskeligere å finne fram til riktige Strand-koder. Målet med programmet er å gjøre denne jobben enklere, og å kunne hente andre lokalitetsdata. 

Programmet returnerer Strand-koder og lokalitetsnavn basert fra en tabell med koordinater. Strand-kodene identifiseres basert på krysninger av punktene beskrevet av input-koordinatene, over polygoner av kommunegrenser. Stedsnavn lastes ned fra sentralt stednavnregister (SSR). For hvert geografiske punkt blir det nærmeste stedsnavnet i SSR returnert.

Input-tabellen må være en tabell med koordinater der lengdegrader og breddegrader er organisert i hver sin kolonne. Koordinatene må ha georeferansesystem longlat WGS84/Euref89. Det går fint å inkludere andre kolonner i tabellen, f.eks. col.event. Strand-koder og nærmeste stedsnavn vil senere bli lagt til den samme tabellen. Programmet fungerer bare med koordinater som treffer innenfor norges terrestrielle romlige grenser.

## Eksempel

Bruk 'devtools' til å laste ned programmet fra github
```{r, eval = FALSE}
require(devtools)
```


### Installer 'strandr'
```{r, eval = FALSE}
install_github("jonpeder/strandr")
```
 


### Importer tabell med koordinater fra en tab-separert tekstfil
Tab-separerte tekstfiler kan enkelt eksporteres fra excel.
NB. For å slippe å skrive hele "filstien" kan det være lettere å legge filen i hjem-mappen til R, som oftest er Documents/Mine dokumenter. Hvis du lurer på hva som er hjem-mappen til R, skriv i kommandolinjen: path.expand("~")
```{r}
eks_inn <- read.table("koordinater.txt", sep = "\t", header = TRUE)
```

### Inspiser importert tabell
```{r}
eks_inn
```
 


### Bruk 'strandr' for å legge Strand-koder og lokalitetsnavn til tabellen
```{r}
library(strandr)
eks_ut <- strandr(eks_inn, long = eks_inn$Longitude, lat = eks_inn$Latitude)
```

### Inspiser den nye tabellen
I tillegg til Strand-koder (Strand_kode) er det i tabellen informasjon om hvilken kommune punktet til koordinatene havner innenfor anno 2018 (Kommune_2018), hvilket stedsnavn (Sted) i SSR som ligger nærmest punktet, hva slags sted navnet gjelder (Type), avstand fra punkt til sted (Dist_m), orientering fra sted mot punkt (Orient), og hvilket fylke (Fylke) og kommune (Kommune) stedet ligger i dag. Det er viktig å merke seg at kommune og fylke for stedet teoretisk sett ikke trenger og sammenfalle med kommune og fylke punktet havner innenfor, f.eks. hvis dette er rett ved en kommunegrense. Kommune anno 2018 er derfor mest korrekt for punktet.
```{r}
eks_ut
```
 

### Eksporter resultatene som tab-separert tekstfil
```{r}
write.table(eks_ut, "eks_ut.txt", sep = "\t", row.names = FALSE, quote = FALSE)
```
