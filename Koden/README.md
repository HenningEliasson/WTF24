# Julkalender

På `index` ska all (24) numrerade "luckor" visas.

Luckorna är formulär med en knapp. När man klickar på formuläret ska man bli redirectad till `show` routen för luckan, och bilden bakom luckan ska visas.

I databasen ska 'opened'-attributet uppdateras för att visa att luckan är öppnad

(Vänta med datumkontroll tills du fått det att fungera utan)

För att kontrollera vilken månad och dag det är i ruby:

```ruby
time = Time.now
time.month #=> returnerar ett heltal från 1 - 12 indikerande vilken månad det är
time.mday #= returnar ett heltal från 1-31 indikerande vilken dag i månaden det är
```

## Databas

Databasen innehåller en tabell (`doors`) och tabellen har tre attribut: `id`, `day` och `opened`.
`id` är ett unikt id för dörren, och representerar inte dagen, då seed-scriptet slumpar i vilken ordning dörrarna läggs in i databasen. 

`day` är vilken dag som avses. Bilden med motsvarande nummer i public-mappen ska visas.

`opened` är en `Boolean` (`true` eller `false`) och indikerar om dörren öppnats eller inte.


## Utseende

Det finns en css-fil som innehåller ett grundläggande rutnät och utseende för luckorna (om ni sätter rätt klasser på html-elementen).

## Bilder

Bilder till luckorna är jpg-bilder ligger i `public/img` och är döpta enligt '\<dagens nummer>.jpg'

Bakgrundsbilden heter `background.jpg`

Obs. Bild 24 saknas. Fixa en lämplig egen bild.

## Server

Kör `bundle install` i projektets rotmapp för att installera dependencies.

Kör `rake seed` i projektets rotmapp för att seeda om databasen.

Kör `rake dev` i projektets rotmapp för att starta servern med rerun.
