#set text(
  font: "Calibri Light",
  size: 11pt
)
#set page(paper: "a4", margin: (x: 1cm, y: 1cm), numbering: "1")
#set heading(numbering: "1.")
#set figure(supplement: none)
#set grid(columns: 2, gutter: 2mm,)
#set pad(x: -0.8cm)





#align(horizon)[
  #align(center)[
    #stack(
      v(12pt),
      text(size: 20pt)[Metody Numeryczne - Aproksymacja profilu wysokościowego],
      v(15pt),
      text(size: 14pt)[Jakub Bronowski, 193208],
      v(10pt),
      text(size: 12pt)[gr. 2, sem. IV]
    )
  ]
]

#align(bottom)[
#outline(title: "Spis treści", target: heading.where(depth: 1))
]
#pagebreak()

= Wstęp

Celem projektu było zaimplementowanie i analiza jakościowa trzech metod interpolacji: dwóch metod Lagrange'a z punkami rozmieszczonymi równomiernie, węzłami Czebyszewa oraz metody funkcji sklejanych (dla równomiernie rozmieszczonych punktów). Analiza jakościowa miała zostać zrealizowana przez interpolację profili wysokościowych wybranych tras. W projekcie przeprowadzono testy dla czterech różnych zbiorów danych wybranych ze zbioru danych umieszczonych na stonie kursu eNauczanie. Wyniki przedstawiono w postaci wykresów. W projekcie porównano również wpływ ilości węzłów na jakość interpolacji jak również wpływ rozmieszczenia węzłów w przypadku metody Lagrange'a.

Projekt zaimplementowano głównie w języku C++ (Visual Studio). Zaimplementowano faktoryzację LU z pivotingiem do rozwiązania układu równań dla metody funkcji sklejanych (zmodyfikowano kod z Projektu nr 2) oraz metody interpolacji według wytycznych z wykładu. Do generowania wykresów wykorzystano język Python z biblioteką `matplotlib`. 

= Opis metod

== Metoda Lagrange'a dla równoodległych węzłów




Metoda Lagrange'a pozwala na obliczenie wielomianu stopnia `n` na podstawie `n+1` węzłów. Jest to jedna z najprostszych metod interpolacji, niewymagająca dużo pracy przy implementacji. Wynik interpolacji Lagrange'a jest taki sam jak wynik metody Vandermonde'a. Jej zaletą jest brak konieczności rozwiązywania układu równań, stabilność numeryczna oraz prostota implementacji.

Metoda Lagrange'a opiera się na bazie funckji wielomianowych tworzonych zgodnie ze wzorem:
$ phi.alt_i (x) = limits(product)_(j=1,j!=i)^(n+1) frac((x - x_j), (x_i - x_j)) $


Wielomian interpolacyjny Lagrange'a składa się z funkcji z bazy pomnożonych przez wartości funkcji w węzłach. Wzór na wielomian interpolacyjny Lagrange'a wygląda następująco:
$ F(x) = sum_(i=1)^(n+1) y_i phi.alt_i (x) $


Pomimo swoich zalet, metoda Lagrange'a posiada poważną wadę, mianowicie podatność efekt Rungego (oscylacje wielomianu interpolacyjnego w okolicach krańców przedziału interpolacji). W celu zminimalizowania tego efektu można zastosować interpolację w węzłach Czebyszewa. W projekcie porównano jakość interpolacji z ich zastosowaniem w stosunku do równoodległych węzłów. 
Węzły Czebyszewa na przedziale $[a, b]$ wznaczano ze wzoru:
$ x_k = frac(a + b, 2) + frac(b - a, 2) cos(frac(2k - 1, 2k) pi), k = 1, ..., n $
a następnie szukano w dziedzinie obliczeniowej najbliższych węzłów do tych wartości.



== Metoda funkcji sklejanych

Metoda funkcji sklejanych polega na wyznaczeniu wielomianu stałego stopnia na każdym z przedziałów między węzłami. Wielomian tworzy się tak, aby były ciągłe oraz, żeby ich  pochodne pierwszego i drugiego rzędu były ciągłe. W projekcie zaimplemetnowano interpolację funkcjami sklejanymi stopnia 3 zdefiniowane jako:
$ S_i (x) = a_i + b_i (x - x_i) + c_i (x - x_i)^2 + d_i (x - x_i)^3 $


Metoda funkcji sklejanych pozwala na wyznaczenie współczynników $a_i, b_i, c_i, d_i$ dla każdego z przedziałów poprzez rozwiązanie układu równań. W projekcie do rozwiązania układu równań wykorzystano faktoryzację LU. Metoda funkcji sklejanych jest bardziej skomplikowana niż metoda Lagrange'a, ale pozwala na uzyskanie lepszych wyników. Jest też odporna na efekt Rungego.
#pagebreak()
Układ równań do rozwiązania dla metody funkcji sklejanych można zapisać jako:
$ S_i (x_i) = y_i, i = 0, ..., n-1 & "Wartość funkcji w węzłach" $
$ S_i (x_(i+1)) = y_(i+1), i = 0, ..., n-1 & "Ciągłość funkcji w węzłach" $
$ S''_0(x_0) = 0 & "Zerowanie drugiej pochodnej w punkcie początkowym" $
$ S''_(n-1)(x_n) = 0 & "Zerowanie drugiej pochodnej w punkcie końcowym" $
$ S'_i (x_i) = S'_(i-1)(x_i), i = 1, ..., n-1 & "Zerowanie pierwszej pochodnej w punktach" $
$ S''_i (x_i) = S''_(i-1)(x_i), i = 1, ..., n-1 & "Zerowanie drugiej pochodnej w punktach" $


= Dane wejściowe
W projekcie przeprowadzono testy dla czterech różnych zbiorów danych. Wszystkie zbiory danych zawierają 512 punktów.
- `chelm.txt` - dane o niewielkiej zmienności wysokości nieprzekraczającej 10 m
- `stale.txt` - dane pokazujące stały wzrost przypominający łagodne zbocze górskie
- `hel_yeah.txt` - dane o bardzo gwałtownie zmieniającej się wysokości między kolejnymi punktami
- `tczew_starogard.txt` - dane o wzroście wysokości z dużymi oscylacjami miejscowymi


Poniżej przedstawiono wykresy dla każdego z nich.


#pad(
  grid(
    figure(image("plots/chelm_all_nodes.png"), caption: "chelm.txt"),
    figure(image("plots/stale_all_nodes.png"), caption: "stale.txt"),
    figure(image("plots/hel_yeah_all_nodes.png"), caption: "hel_yeah.txt"),
    figure(image("plots/tczew_starogard_all_nodes.png"), caption: "tczew_starogard.txt")
  )
)

= Wyniki interpolacji metodą Lagrange'a dla równoodległych węzłów

Dla każdego zbioru danych przeprowadzono interpolację metodą Lagrange'a dla 10, 20, 50, i 100 węzłów wejściowych. Wartości wybranych węzłów są rozmieszczone równomiernie. Liczba węzłów została dobrana tak, aby umożliwić wybranie z 512 punktów węzłów równoodległych.

Za pomocą interpolacji Lagrange'a obliczono wartości funkcji w 512 punktach. Poniżej przedstawiono wykresy interpolacji dla każdego zbioru danych.

== Interpolacja Lagrange'a (linspace) - chelm.txt
  #pad(
    grid(
      figure(image("plots/chelm_10_linspace.png"), caption: "10 węzłów"),
      figure(image("plots/chelm_20_linspace.png"), caption: "20 węzłów"),
      figure(image("plots/chelm_50_linspace.png"), caption: "50 węzłów"),
      figure(image("plots/chelm_100_linspace.png"), caption: "100 węzłów")
    )
  )
      Jak możemy zauważyć na powyższych wykresach, uzyskane wyniki interpolacji nie przybliżają dobrze oryginalnych danych. O ile dałoby się obronić interpolację 10 węzłami (z przymknięciem oka na krańce przedziału interpolacji) to dla 20 punktów nie ma takiej możliwości. Dokładność interpolacji zaburzona jest przez efekt Rungego. W okolicach krańców przedziału pojawiają się oscylacje wielomianu interpolacyjnego o co najmniej rząd wielkości. Dla 50 punktów amplituda drgań wielomianu interpolacyjnego jest olbrzymia, sięgająca nawet $10^10$ na krańcach przedziału. Dla 100 węzłów tylko połowa środkowa cześć wykresu ma szansę być jakkolwiek aproksymowana. Lewe i prawe ćwiartki osiągają wartości sięgające $10^25$.  Wniosek jest prosty: zastosowanie większej ilości węzłów tylko pogarsza jakość interpolacji, a im więcej węzłów tym większe zaburzenia spowodowane efektem Rungego.
      #pagebreak()

== Interpolacja Lagrange'a (linspace) - stale.txt
  #pad(
    grid(
      figure(image("plots/stale_10_linspace.png"), caption: "10 węzłów"),
      figure(image("plots/stale_20_linspace.png"), caption: "20 węzłów"),
      figure(image("plots/stale_50_linspace.png"), caption: "50 węzłów"),
      figure(image("plots/stale_100_linspace.png"), caption: "100 węzłów")
    )
  )
    Obserwując wykresy powstałe przy interpolacji danych z pliku `stale.txt` zauważamy, że wyniki interpolacji są bardzo zaburzone przez efekt Rungego. Występuje on już przy 10 węzłąch. Już dla 20 węzłów widzimy duże odchylenie między punktami na skrajach wykresu. Użycie większej ilości węzłów tylko pogarsza wyniki. Widać wyraźnie, że nasila się efekt Rungego, czyli oscylacje wielomianu interpolacyjnego w okolicach krańców przedziału. Już przy 50 węzłach wynik interpolacji jest bardzo zaburzony i nie nadaje się do dalszych analiz. Warto nadmienić, że ze względu na specyfikę danych wejściowych wykres został zinterpolowany najlepiej dla małej ilości węzłów. Środkowa część wykresu przedstawiającego wyniki interpolacji dość dobrze pokrywa się z oryginalnym wykresem.
    #pagebreak()
  
== Interpolacja Lagrange'a (linspace) - hel_yeah.txt
  #pad(
    grid(
      figure(image("plots/hel_yeah_10_linspace.png"), caption: "10 węzłów"),
      figure(image("plots/hel_yeah_20_linspace.png"), caption: "20 węzłów"),
      figure(image("plots/hel_yeah_50_linspace.png"), caption: "50 węzłów"),
      figure(image("plots/hel_yeah_100_linspace.png"), caption: "100 węzłów")
    )
  )
    Zestaw `hel_yeah` okazał się za trudny dla metody Lagrange'a. Ponownie wyniki interpolacji są bardzo zaburzone przez efekt Rungego. Już dla 10 węzłów widzimy duże odchylenie między dwoma pierwszymi punktami. Użycie większej ilości węzłów tylko pogarsza wyniki. Widać wyraźnie, że nasila się efekt Rungego, czyli oscylacje wielomianu interpolacyjnego w okolicach krańców przedziału. Już przy 10 węzłach wynik interpolacji jest bardzo zaburzony. Żadna ilość węzłów nie była w stanie jakkolwiek dopasować się do oryginalnych danych.
    #pagebreak()

== Interpolacja Lagrange'a (linspace) - tczew_starogard.txt
  #pad(
    grid(
      figure(image("plots/tczew_starogard_10_linspace.png"), caption: "10 węzłów"),
      figure(image("plots/tczew_starogard_20_linspace.png"), caption: "20 węzłów"),
      figure(image("plots/tczew_starogard_50_linspace.png"), caption: "50 węzłów"),
      figure(image("plots/tczew_starogard_100_linspace.png"), caption: "100 węzłów")
    )
  )
    Wyniki interpolacji dla tego zestawu również są silnie zaburzone przez efekt Rungego. Nawet dla 10
    węzłów widzimy duże odchylenie między dwoma pierwszymi punktami. Użycie większej ilości węzłów
    tylko pogarsza wyniki. Efekt Rungego jest wyraźnie obserwowalny od 20 węzłów. Wykorzystanie 10 węzłów oddaje jednak ogólny trend trasy między Tczewem a Starogardem, choć z dużym błędem co do konkretnych wartości. Jenakże wielomian interpolacyjny wskazuje ogólne zmiany wysokości na odcinkach co 5000 m. Dla większej ilości węzłów nie widać żadnych podobieństw do oryginalnej trasy.



== Podsumowanie interpolacji metodą Lagrange'a dla równoodległych węzłów

Jak można zauważyć, wyniki interpolacji metodą Lagrange'a nie spełniają oczekiwań. W ogólnym przypadku niepoprawnie iterpolują każdą z badancych tras. W przypadku małej ilości węzłów (10) wyniki są mało dokładne, ale za to efekt Rungego jest słaby. Wraz ze wzrostem ilości węzłów, wyniki interpolacji pogarszają się znacząco. Widać wyraźnie, że nasila się efekt Rungego, czyli oscylacje wielomianu interpolacyjnego w okolicach krańców przedziału. Już przy 20 węzłach wynik interpolacji jest bardzo zaburzony a wyznaczony profil wysokościowy jest gorzej niż błędny. 
Jedyną względnie dobrą interpolacją okazała się być ta dla 10 węzłów dla danych z pliku `stale.txt` (grzbiet bardzo bliski dodatnio nachylonej prostej - rzadki przypadek). Dla danych z pliku `tczew_starogard.txt` wykres interpolacji dla 10 węzłów oddaje ogólny trend trasy między Tczewem a Starogardem, choć z dużym błędem co do konkretnych wartości. 
#pagebreak()

= Wyniki interpolacji metodą Lagrange'a dla węzłów Czebyszewa

W celu zminimalizowania efektu Rungego zastosowano interpolację metodą Lagrange'a dla węzłów Czebyszewa. Z racji tego, że nie znamy danych wejściowych, nie jesteśmy w stanie idealnie dobrać węzłów Czebyszewa. W projekcie wybrano z węzłów wejściowych bez powtórzeń te, które są najbliżej "prawdziwych matematycznie" węzłów Czebyszewa.


== Interpolacja Lagrange'a (węzły Czebyszewa) - chelm.txt
   #pad(
    grid(
      figure(image("plots/chelm_10_chebyshev.png"), caption: "10 węzłów"),
      figure(image("plots/chelm_20_chebyshev.png"), caption: "20 węzłów"),
      figure(image("plots/chelm_50_chebyshev.png"), caption: "50 węzłów"),
      figure(image("plots/chelm_100_chebyshev.png"), caption: "100 węzłów")
    )
  )
     Jak widać na powyższych wykresach, interpolacja metodą Lagrange’a dla węzłów Czebyszewa jest
      bardziej stabilna niż dla równoodległych węzłów. Zwiększenie ilości węzłów nie wpływa w tym
      przypadku negatywnie na wyniki. Wynik interpolacji jest dobry i pozwala na uzyskanie dokładnych
      wyników. Nawet użycie 100 węzłów nie powoduje wystąpienia efektu Rungego. Potencjalne zaburzenia
      związane z wyborem węzłów Czebyszewa nie są widoczne na wykresach o ilości węzłów nie mniejszej niż 50.
      Zwiększenie ilości węzłów stopniowo pozwala poprawić jakość interpolacji.
      #pagebreak()

== Interpolacja Lagrange'a (węzły Czebyszewa) - stale.txt
  #pad(
    grid(
      figure(image("plots/stale_10_chebyshev.png"), caption: "10 węzłów"),
      figure(image("plots/stale_20_chebyshev.png"), caption: "20 węzłów"),
      figure(image("plots/stale_50_chebyshev.png"), caption: "50 węzłów"),
      figure(image("plots/stale_100_chebyshev.png"), caption: "100 węzłów")
    )
  )
    Na tym zestawie danych obserwujemy ciekawą rzecz. Już dla 10 węzłów interpolacyjnych poziom dopasowania jest zadowalający. Dla ilości węzłów nie mniejszej niż 20 różnice pomiędzy kolejnymi próbami są niewielkie. Widać, że zwiększenie ilości węzłów nie wpływa negatywnie na wyniki, a wręcz przeciwnie. Wyniki interpolacji są bardzo dobre a obrana strategia pozwala na uzyskanie dokładnych wartości. Dla funkcji przypominających łagodne zbocze górskie interpolacja metodą Lagrange'a dla węzłów Czebyszewa jest bardzo skuteczna już dla 20 węzłów.
    #pagebreak()
  
== Interpolacja Lagrange'a (węzły Czebyszewa) - hel_yeah.txt
  #pad(
    grid(
      figure(image("plots/hel_yeah_10_chebyshev.png"), caption: "10 węzłów"),
      figure(image("plots/hel_yeah_20_chebyshev.png"), caption: "20 węzłów"),
      figure(image("plots/hel_yeah_50_chebyshev.png"), caption: "50 węzłów"),
      figure(image("plots/hel_yeah_100_chebyshev.png"), caption: "100 węzłów")
    )
  )
    W najtrudniejszym jak dotąd teście metoda interpolacji Lagrange’a z węzłami Czebyszewa nie odniosła całkowitej porażki. Faktem jest, że interpolacje jakkolwiek pokrywające się z oryginalnymi danymi uzyskano dopiero dla 50 węzłów. Dla 10 węzłów wyniki są bardzo zaburzone, z wielkim dołem w 75% szerokości wykresu. Rzeczone zjawisko występuje dla każdej z analizowanych ilości węzłów, choć wraz z przyrostem ilości węzłów doły są coraz płytsze i węższe. Efekt ten najsłabiej widać dla 50 węzłów, co jednak nie oznacza, że interpolacja ta jest idealna. 
    Każda z metod nie radzi sobie dobrze w prawym krańcu dziedziny, gdzie obserwujemy bardzo gęste i gwałtowne zmiany wysokości w przedziale $[10^0, 10^1]$ m.
    #pagebreak()

== Interpolacja Lagrange'a (węzły Czebyszewa) - tczew_starogard.txt
  #pad(
    grid(
      figure(image("plots/tczew_starogard_10_chebyshev.png"), caption: "10 węzłów"),
      figure(image("plots/tczew_starogard_20_chebyshev.png"), caption: "20 węzłów"),
      figure(image("plots/tczew_starogard_50_chebyshev.png"), caption: "50 węzłów"),
      figure(image("plots/tczew_starogard_100_chebyshev.png"), caption: "100 węzłów")
    )
  )
    Wyniki interpolacji dla tego zestawu danych są dobre dla 50 i więcej węzłów. W przeciwieństwie do poprzednich rozważań ani 10 ani 20 węzłów interpolacyjnych nie oddają charakteru trasy. Dla 50 węzłów widać wyraźnie trendy lokalne w bardzo wąskich przedziałach. Dla 100 węzłów interpolacja jest bardzo dokładna i pokrywa oryginalny wykres w 90%, przy czym obszary niepokryte są wąskie i w różnych częściach wykresu (są to strome szczyty lub doliny o bardzo stromych zboczach i o niewielkiej wysokości).

== Podsumowanie interpolacji metodą Lagrange'a dla węzłów Czebyszewa
Jak można wywnioskować z powyższych wykresów, interpolacja metodą Lagrange'a dla węzłów Czebyszewa jest bardziej stabilna niż dla równoodległych węzłów. Dla trzech z czterech zestawów danych uzyskano dobre wyniki. Efekt Rungego nie został zaobserwowany. Nawet dla 100 węzłów interpolacja jest bardzo dokładna. Należy pamiętać, że użycie węzłów Czebyszewa może mieć negatywny wpływ na jakość interpolacji w środku przedziału.

W przypadku jednego zestawu danych, wyniki interpolacji dla węzłów Czebyszewa nie spełniają oczekiwań. Pokazuje to, że pomimo zastosowania węzłów Czebyszewa, nie zawsze jesteśmy w stanie uzyskać dokładną interpolację. Wyniki uzyskane tą metodą są lepsze niż dla równoodległych węzłów, ale nie są idealne. Dlatego metoda Lagrange'a nie jest odpowiednia do interpolacji profilu wysokościowego, w szczególności dla tras o dużych zmianach wysokości, w szczególności na krótkich odcinkach.

Warto zauważyć, że w przypadku dużcyh danych wejściowych (512 punktów), wybór węzłów Czebyszewa był możliwy, choć nie obyło się bez komplikacji. W praktyce, dla mniejszej ilości danych, dobór węzłów Czebyszewa może być trudny ze względu na niedostatecznie dużą koncentrację danych na skrajach przedziału. 


= Wyniki interpolacji metodą funkcji sklejanych

Dla każdego zbioru danych przeprowadzono interpolację metodą funkcji sklejanych. W projekcie zaimplementowano interpolację funkcjami sklejanymi stopnia 3. Również dla tej metody wybrano odpowiednio 10, 20, 50, 100 węzłów wejściowych. Wartości wybranych węzłów są rozmieszczone równomiernie. Na ich podstawie obliczono wartości funkcji w 512 punktach. Poniżej przedstawiono wykresy interpolacji dla każdego zbioru danych.

== Interpolacja funkcjami sklejanymi - chelm.txt
   #pad(
    grid(
      figure(image("plots/chelm_10_spline.png"), caption: "10 węzłów"),
      figure(image("plots/chelm_20_spline.png"), caption: "20 węzłów"),
      figure(image("plots/chelm_50_spline.png"), caption: "50 węzłów"),
      figure(image("plots/chelm_100_spline.png"), caption: "100 węzłów")
    )
  )
    Metoda funkcji sklejanych pozwala na uzyskanie bardzo dokładnych wyników interpolacji. Już dla 20
    węzłów wynik interpolacji przypomina oryginalną funkcję, a dla 10 węzłów wyrażnie widać tendencję trasy w szerokich (kolejne ćwiartki dziedziny) przedziałach. Dla 50 czy 100 węzłów interpolacja jest
    bardzo dokładna i pokrywa się w całości z oryginalnymi danymi. Jak również możemy zauważyć, metoda funkcji sklejanych jest odporna na efekt Rungego. Pozwala to na zwiększenie ilości węzłów bez obaw o pogorszenie wyników. Efekty są bardzo dobre, najlepsze z dotychczas obserwowanych.
    #pagebreak()

== Interpolacja funkcjami sklejanymi - stale.txt
  #pad(
    grid(
      figure(image("plots/stale_10_spline.png"), caption: "10 węzłów"),
      figure(image("plots/stale_20_spline.png"), caption: "20 węzłów"),
      figure(image("plots/stale_50_spline.png"), caption: "50 węzłów"),
      figure(image("plots/stale_100_spline.png"), caption: "100 węzłów")
    )
  )
    Dla najmniej wymagającego testu w badanym zestawie tras interpolacja na 10 węzłach w 95% pokrywa oryginalny przebieg. Brakujące 5% rozrzucone jest równomiernie po całej trasie a wysokość "odkształceń jest niewielka". Dla 20 węzłów możnaby zakończyć dalsze badania, wynik w 99% pokrywa się z oryginalnym przebiegiem. Dla 50 węzłów interpolacja jest bardzo dokładna i pokrywa się w całości z oryginalnymi danymi. Różnica między 50 i 100 węzłami jest niewidoczna nieuzbrojonym okiem (identyczna gładkość funkcji).
    #pagebreak()
  
== Interpolacja funkcjami sklejanymi - hel_yeah.txt
  #pad(
    grid(
      figure(image("plots/hel_yeah_10_spline.png"), caption: "10 węzłów"),
      figure(image("plots/hel_yeah_20_spline.png"), caption: "20 węzłów"),
      figure(image("plots/hel_yeah_50_spline.png"), caption: "50 węzłów"),
      figure(image("plots/hel_yeah_100_spline.png"), caption: "100 węzłów")
    )
  )
    Dla najtrudniejszego zestawu danych testowych metoda splajanów sprawiła się najlepiej. Podobnie jak poprzednio interpolacje dla 10 i 20 węzłów nie nadają się do dalszego przetwarzania. Doły obserwowane poprzednio również występują, ale tylko dla 10, 20 i 50 węzłów; dla 100 węzłów są niewidoczne. Dla 50 węzłów interpolacja jest bardzo dokładna i pokrywa się w z oryginalnymi danymi w pierwszej połowie wykresu. Końcówka trasy cechująca się gwałtownymi zmianami wysokości jest zinterpretowana jako gładka funkcja, która tylko oddaje stosunkowo ogólną zmienność (przyrost / spadek wysokości). Dla 100 węzłów interpolacja jest bardzo dokładna i pokrywa się w z oryginalnymi danymi w zadowalającym stopniu. 60% wykresu patrząc od lewej strony jest pokryte idealnie. Pozostałe 40% to obszary o gwałtownych zmianach wysokości, które są interpretowane jak dotąd najdokładniej (dobrze wskazuje monotoniczność trasy, ale nie należy się kierować wartościami wysokości).
    #pagebreak()

== Interpolacja funkcjami sklejanymi - tczew_starogard.txt
  #pad(
    grid(
      figure(image("plots/tczew_starogard_10_spline.png"), caption: "10 węzłów"),
      figure(image("plots/tczew_starogard_20_spline.png"), caption: "20 węzłów"),
      figure(image("plots/tczew_starogard_50_spline.png"), caption: "50 węzłów"),
      figure(image("plots/tczew_starogard_100_spline.png"), caption: "100 węzłów")
    )
  )
    Wyniki interpolacji dla tego zestawu danych są dobre dla 50 węzłów. 10 węzłów pokazuje ogólną monotoniczność trasy, zachowane są też cechy lokalnych zmian (z dokładnością do duża/małe zmiana wysokości). Przy użyciu 20 węzłów oba wykresy miejscami pokrywają się. 50 węzłów pokazuje ogólny trend trasy między Tczewem a Starogardem, z niedużym błędem co do konkretnych wartości. Poziom pokrycia jest wysoki, dużo większy niż dla metody Lagrange’a z węzłami Czebyszewa. Dla 100 węzłów interpolacja jest bardzo dokładna i pokrywa oryginalny wykres w 99%. 

== Podsumowanie interpolacji metodą funkcji sklejanych

Interpolacja metodą funkcji sklejanych pozwala na uzyskanie bardzo dokładnych wyników. Nawet przy 20 węzłach wejściowych wynik interpolacji powoli przypomina oryginalną funkcję. W zależności od danych, 10 węzłów można wykorzystać do ogólnego opisu przebiegu trasy (np. bardzo stroma, stosunkowo łagodne wzniesienia itp.). Dla 50  węzłów interpolacja jest dobra. Najlepsze efekty obserwuje się przy 100 węzłach. Jak również możemy zauważyć, metoda funkcji sklejanych jest odporna na efekt Rungego. Pozwala to na zwiększenie ilości węzłów bez obaw o pogorszenie wyników. Warto zauważyć, że metoda funkcji sklejanych, w przeciwieństwie do metody Lagrange'a, spełnia swoje zadanie dla danych równomiernie rozmieszczonych. Ilość węzłów można też zwiększać mocniej niż w przypadku metody Lagrange’a z węzłami Czebyszewa. 

Warto także zauważyć, że metoda ta nie gwarantuje idealnej interpolacji dla każdych danych. W pewnych przypadkach, jak dla danych z pliku `hel_yeah.txt`, tylko mniej gwałtownie zmieniająca się część oryginalnej trasy została zinterpolowana bardzo dobrze.

#pagebreak()

= Podsumowanie

W uzyskanych wyników interpolacji można zauważyć, że metoda Lagrange'a dla węzłów równoodległych nie jest odpowiednia do interpolacji profilu wysokościowego. Dla małej ilości węzłów wejściowych wyniki są mało dokładne, a po ich zwiększeniu pojawia się efekt Rungego który wzmacnia się wraz z przyrostem ilości węzłów interpolacji. Zastosowanie węzłów Czebyszewa pozwala na zminimalizowanie tego efektu, ale nie jest to rozwiązanie idealne. Wymagany jest wybór nierównomiernie rozmieszczonych węzłów, co jest trudne do osiągnięcia w praktyce, zwłaszcza dla danych o niskim zagęszczeniu punktów przy krańcach badanego przedziału. Metoda Lagrange'a będzie lepsza dla tras bardzo gęsto próbkowanych, choć nie daje to gwarancji dostatecznie dobrych rezultatów.

Metoda funkcji sklejanych pozwala na uzyskanie bardzo dokładnych wyników interpolacji. Jest ona odporna na efekt Rungego, co pozwala na zwiększanie ilości węzłów bez obaw o pogorszenie wyników. Metoda funkcji sklejanych spełnia swoje zadanie dla danych równomiernie rozmieszczonych, co jest idealne w przypadku profilu wysokościowego. Dość dobrze radzi sobie z danymi bardzo gwałtownie zmieniającymi się na małym podprzedziale, ale nie gwarantuje idealnej interpolacji dla każdych danych w całej dziedzinie (patrz: `hel_yeah`).

Podsumowując, pomimo większej trudności implementacyjnej, metoda funkcji sklejanych jest bardziej odpowiednia do interpolacji profilu wysokościowego niż metody Lagrange'a. Pozwala ona na uzyskanie dokładnych wyników nawet dla małej ilości węzłów wejściowych. Możemy poprawić jakość interpolacji poprzez zwiększenie ilości węzłów, co nie wpłynie negatywnie na wyniki. Metoda funkcji sklejanych jest również bardziej odporna na efekt Rungego, co pozwala na uzyskanie dokładnych wyników bez obaw o zaburzenia.