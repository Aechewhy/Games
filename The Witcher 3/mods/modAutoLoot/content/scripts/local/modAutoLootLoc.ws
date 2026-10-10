/***********************************************************************/
/** 	AutoLoot Next-Gen Mod - Localization Helper
/** 	Dynamically adapts strings to the current game language.
/***********************************************************************/

function AutoLoot_GetGameTextLanguage() : string
{
	var audioLang, textLang : string;
	var sample : string;

	theGame.GetGameLanguageName( audioLang, textLang );
	if ( textLang != "" )
	{
		if ( StrUpper(textLang) == "BR" || StrUpper(textLang) == "PT" || StrUpper(textLang) == "PT-BR" || StrUpper(textLang) == "PT_BR" || StrUpper(textLang) == "POR" )
		{
			return "BR";
		}
		if ( StrUpper(textLang) == "ZT" || StrUpper(textLang) == "TW" || StrUpper(textLang) == "ZH-TW" || StrUpper(textLang) == "ZH_TW" || StrUpper(textLang) == "ZHT" || StrUpper(textLang) == "ZH-HK" )
		{
			return "ZT";
		}
		if ( StrUpper(textLang) == "ZH" || StrUpper(textLang) == "CN" || StrUpper(textLang) == "ZH-CN" || StrUpper(textLang) == "ZH_CN" || StrUpper(textLang) == "CHS" || StrUpper(textLang) == "ZHO" )
		{
			// Check if actual localized sample uses Traditional characters
			sample = GetLocStringByKeyExt( "menu_cannot_perform_action_now" );
			if ( StrFindFirst( sample, "無" ) >= 0 || StrFindFirst( sample, "目前" ) >= 0 || StrFindFirst( sample, "此操作" ) >= 0 )
			{
				return "ZT";
			}
			return "ZH";
		}
		return textLang;
	}

	sample = GetLocStringByKeyExt( "menu_cannot_perform_action_now" );
	if ( StrFindFirst( sample, "Nie możesz" ) >= 0 || StrFindFirst( sample, "nie możesz" ) >= 0 )
	{
		return "PL";
	}
	if ( StrFindFirst( sample, "nicht möglich" ) >= 0 || StrFindFirst( sample, "Aktion" ) >= 0 )
	{
		return "DE";
	}
	if ( StrFindFirst( sample, "Impossible" ) >= 0 || StrFindFirst( sample, "impossible" ) >= 0 )
	{
		return "FR";
	}
	if ( StrFindFirst( sample, "невозможно" ) >= 0 || StrFindFirst( sample, "Невозможно" ) >= 0 )
	{
		return "RU";
	}
	if ( StrFindFirst( sample, "possível" ) >= 0 || StrFindFirst( sample, "ação" ) >= 0 )
	{
		return "BR";
	}
	if ( StrFindFirst( sample, "無" ) >= 0 || StrFindFirst( sample, "目前" ) >= 0 || StrFindFirst( sample, "此操作" ) >= 0 )
	{
		return "ZT";
	}
	if ( StrFindFirst( sample, "无" ) >= 0 || StrFindFirst( sample, "当前" ) >= 0 || StrFindFirst( sample, "该操作" ) >= 0 )
	{
		return "ZH";
	}

	return "EN";
}

function AutoLoot_IsPolishLanguage() : bool
{
	return AutoLoot_GetGameTextLanguage() == "PL";
}

function AutoLoot_GetTheftWarnMessage() : string
{
	var lang : string;
	lang = AutoLoot_GetGameTextLanguage();

	if ( lang == "PL" )
	{
		return "[AutoLoot] Pominięto kradzież - w pobliżu są świadkowie lub straż!";
	}
	else if ( lang == "DE" )
	{
		return "[AutoLoot] Diebstahl übersprungen - Zeugen oder Wachen in der Nähe!";
	}
	else if ( lang == "RU" )
	{
		return "[AutoLoot] Кража отменена - рядом стражники или свидетели!";
	}
	else if ( lang == "FR" )
	{
		return "[AutoLoot] Vol annulé - des témoins ou des gardes sont proches!";
	}
	else if ( lang == "BR" )
	{
		return "[AutoLoot] Roubo ignorado - testemunhas ou guardas por perto!";
	}
	else if ( lang == "ZH" )
	{
		return "[AutoLoot] 已跳过偷窃 - 附近有目击者或守卫！";
	}
	else if ( lang == "ZT" )
	{
		return "[AutoLoot] 已略過偷竊 - 附近有目擊者或守衛！";
	}
	return "[AutoLoot] Steal skipped - witnesses or guards nearby!";
}

function AutoLoot_GetAndMoreText( count : int ) : string
{
	var lang : string;
	lang = AutoLoot_GetGameTextLanguage();

	if ( lang == "PL" )
	{
		return " i " + count + " inne";
	}
	else if ( lang == "DE" )
	{
		return " und " + count + " weitere";
	}
	else if ( lang == "RU" )
	{
		return " и еще " + count;
	}
	else if ( lang == "FR" )
	{
		return " et " + count + " autres";
	}
	else if ( lang == "BR" )
	{
		return " e mais " + count;
	}
	else if ( lang == "ZH" )
	{
		return " 还有 " + count + " 件";
	}
	else if ( lang == "ZT" )
	{
		return " 還有 " + count + " 件";
	}
	return " and " + count + " more";
}

function AutoLoot_GetLocalizationString( key : string ) : string
{
	var lang : string;
	var lowerKey : string;
	lang = AutoLoot_GetGameTextLanguage();
	lowerKey = StrLower( key );

	if ( StrBeginsWith( lowerKey, "mods." ) )
	{
		lowerKey = StrAfterFirst( lowerKey, "mods." );
	}
	if ( StrBeginsWith( key, "Mods." ) )
	{
		key = StrAfterFirst( key, "Mods." );
	}
	else if ( StrBeginsWith( key, "mods." ) )
	{
		key = StrAfterFirst( key, "mods." );
	}

	if ( lowerKey == "mods" || lowerKey == "panel_mods" || lowerKey == "option_mods" )
	{
		if ( lang == "PL" ) return "Mody";
		if ( lang == "RU" ) return "Моды";
		if ( lang == "ZH" ) return "模组";
		if ( lang == "ZT" ) return "模組";
		return "Mods";
	}

	if ( lang == "PL" )
	{
		switch ( key )
		{
			case "mods": return "Mody";
			case "Mods": return "Mody";
			case "panel_mods": return "Mody";
			case "option_mods": return "Mody";
			case "mod_autoloot_group": return "AutoLoot";
			case "mod_autoloot_enabled": return "Włącz AutoLoot";
			case "mod_autoloot_mode": return "Tryb zbierania";
			case "mod_autoloot_mode_both": return "W promieniu + na interakcję";
			case "mod_autoloot_mode_passive": return "Ciągły w promieniu (pasywny)";
			case "mod_autoloot_mode_interact": return "Pojedynczy na interakcję";
			case "mod_autoloot_mode_interact_aoe": return "Obszarowy (AoE) na interakcję";
			case "mod_autoloot_passive_herbs": return "Pasywne zbieranie ziół (w tle)";
			case "mod_autoloot_radius": return "Zasięg zbierania (metry)";
			case "mod_autoloot_custom_radii": return "Niezależne zasięgi dla kategorii";
			case "mod_autoloot_radius_herbs": return "Zasięg: Zioła i rośliny (m)";
			case "mod_autoloot_radius_corpses": return "Zasięg: Zwłoki i potwory (m)";
			case "mod_autoloot_radius_containers": return "Zasięg: Skrzynie i pojemniki (m)";
			case "mod_autoloot_interval": return "Częstotliwość skanowania";
			
			// HUD
			case "mod_autoloot_hud_style": return "Powiadomienia zebranych łupów (HUD)";
			case "mod_autoloot_hud_bottom_right": return "Ikonki w prawym dolnym rogu";
			case "mod_autoloot_hud_bottom_left": return "Ikonki w lewym dolnym rogu";
			case "mod_autoloot_hud_minimal": return "Tylko tekst na dole ekranu";
			case "mod_autoloot_hud_off": return "Wyłączone (Ciche zbieranie)";
			case "mod_autoloot_hud_right_center": return "Prawa strona (obok Geralta)";
			case "mod_autoloot_hud_box": return "Ciemne okienko łupu (Styl gry / Box)";
			case "mod_autoloot_hud_scale": return "Rozmiar powiadomień (%)";
			case "mod_autoloot_hud_opacity": return "Przezroczystość powiadomień (%)";
			case "mod_autoloot_hud_group": return "HUD: Grupuj identyczne przedmioty";
			case "mod_autoloot_hud_herbs": return "HUD: Pokazuj zioła";
			case "mod_autoloot_hud_equipment": return "HUD: Pokazuj broń i pancerze";
			case "mod_autoloot_hud_alchemy": return "HUD: Pokazuj alchemię i rzemiosło";
			case "mod_autoloot_hud_books": return "HUD: Pokazuj książki i dokumenty";
			case "mod_autoloot_hud_junk": return "HUD: Pokazuj śmieci";
			case "mod_autoloot_hud_money": return "HUD: Pokazuj korony i waluty";

			// Kradzież i straż
			case "mod_autoloot_theft_mode": return "Zabezpieczenie przed kradzieżą";
			case "mod_autoloot_theft_smart": return "Inteligentne (Pomiń gdy ktoś widzi i będą konsekwencje)";
			case "mod_autoloot_theft_never": return "Nigdy nie kradnij (Pomiń każdą własność innych)";
			case "mod_autoloot_theft_strict": return "Ostrożne (Pomiń gdy strażnik w pobliżu)";
			case "mod_autoloot_theft_always": return "Zawsze kradnij (Ignoruj straż i świadków)";
			case "mod_autoloot_theft_radius": return "Zasięg wykrywania straży/świadków (m)";
			case "mod_autoloot_theft_los": return "Sprawdzaj linię wzroku świadków";
			case "mod_autoloot_theft_angle": return "Sprawdzaj kąt patrzenia świadka (100° FOV)";
			case "mod_autoloot_theft_notify": return "Powiadomienie o pominięciu kradzieży";
			
			// Źródła
			case "mod_autoloot_filter_herbs": return "Zbieraj zioła";
			case "mod_autoloot_filter_corpses": return "Zbieraj ze zwłok i szczątków potworów";
			case "mod_autoloot_filter_chests": return "Zbieraj ze skrzyń i kufrów";
			case "mod_autoloot_filter_containers": return "Zbieraj z worków, beczek i paczek";
			case "mod_autoloot_filter_poi": return "Zbieraj skarby eksploracji (PoI)";
			case "mod_autoloot_filter_quest": return "Zbieraj przedmioty questowe";
			
			// Kategorie
			case "mod_autoloot_filter_equipment": return "Zbieraj broń i pancerze";
			case "mod_autoloot_ignore_common_equipment": return "Ignoruj pospolity (biały) ekwipunek";
			case "mod_autoloot_filter_alchemy": return "Zbieraj alchemię i rzemiosło";
			case "mod_autoloot_filter_books": return "Zbieraj książki i dokumenty";
			case "mod_autoloot_filter_junk": return "Zbieraj przedmioty bezwartościowe (śmieci)";
			case "mod_autoloot_filter_money": return "Zbieraj korony i waluty";
			
			// Warunki
			case "mod_autoloot_combat": return "Wyłącz podczas walki";
			case "mod_autoloot_horse": return "Wyłącz podczas jazdy konno";
			case "mod_autoloot_weight": return "Zabezpieczenie przed przeciążeniem";
			case "mod_autoloot_instant_interact": return "Natychmiastowy łup przy interakcji (bez okna)";
			case "mod_autoloot_sound": return "Dźwięk podniesienia przedmiotu";
			case "mod_autoloot_herb_anim": return "Animacja zbierania ziół";
		}
	}
	else if ( lang == "DE" )
	{
		switch ( key )
		{
			case "mods": return "Mods";
			case "panel_mods": return "Mods";
			case "option_mods": return "Mods";
			case "mod_autoloot_group": return "AutoLoot";
			case "mod_autoloot_enabled": return "AutoLoot aktivieren";
			case "mod_autoloot_mode": return "Plünder-Modus";
			case "mod_autoloot_mode_both": return "Radius + Bei Interaktion";
			case "mod_autoloot_mode_passive": return "Nur passiver Umkreis";
			case "mod_autoloot_mode_interact": return "Nur einzelnes Objekt bei Interaktion";
			case "mod_autoloot_mode_interact_aoe": return "Bereichsplündern (AoE) bei Interaktion";
			case "mod_autoloot_passive_herbs": return "Passives Kräutersammeln (im Hintergrund)";
			case "mod_autoloot_radius": return "Plünder-Radius (Meter)";
			case "mod_autoloot_custom_radii": return "Unabhängige Radien für Kategorien";
			case "mod_autoloot_radius_herbs": return "Radius: Kräuter und Pflanzen (m)";
			case "mod_autoloot_radius_corpses": return "Radius: Leichen und Monster (m)";
			case "mod_autoloot_radius_containers": return "Radius: Truhen und Behälter (m)";
			case "mod_autoloot_interval": return "Scan-Intervall";
			case "mod_autoloot_hud_style": return "HUD-Beuteanzeige";
			case "mod_autoloot_hud_bottom_right": return "Icons unten rechts";
			case "mod_autoloot_hud_bottom_left": return "Icons unten links";
			case "mod_autoloot_hud_minimal": return "Nur Textnachricht unten";
			case "mod_autoloot_hud_off": return "Deaktiviert (Lautlos)";
			case "mod_autoloot_hud_right_center": return "Rechte Bildschirmmitte (Beutefenster)";
			case "mod_autoloot_hud_box": return "Dunkles Beutefenster (Spiel-Box)";
			case "mod_autoloot_hud_scale": return "HUD-Feed: Skalierung der Elemente (%)";
			case "mod_autoloot_hud_opacity": return "HUD-Feed: Deckkraft (%)";
			case "mod_autoloot_hud_group": return "HUD-Feed: Identische Gegenstände bündeln";
			case "mod_autoloot_hud_herbs": return "HUD-Feed: Kräuter anzeigen";
			case "mod_autoloot_hud_equipment": return "HUD-Feed: Waffen & Rüstungen anzeigen";
			case "mod_autoloot_hud_alchemy": return "HUD-Feed: Alchemie & Handwerk anzeigen";
			case "mod_autoloot_hud_books": return "HUD-Feed: Bücher & Dokumente anzeigen";
			case "mod_autoloot_hud_junk": return "HUD-Feed: Trödel anzeigen";
			case "mod_autoloot_hud_money": return "HUD-Feed: Geld anzeigen";
			case "mod_autoloot_theft_mode": return "Diebstahl- & Wachenschutz";
			case "mod_autoloot_theft_smart": return "Intelligent (Überspringen, wenn Zeugen & Konsequenzen)";
			case "mod_autoloot_theft_never": return "Niemals stehlen (Fremdbesitz überspringen)";
			case "mod_autoloot_theft_strict": return "Strikt (Überspringen, wenn Wache in der Nähe)";
			case "mod_autoloot_theft_always": return "Immer stehlen (Wachen ignorieren)";
			case "mod_autoloot_theft_radius": return "Wachen-Erkennungsradius (m)";
			case "mod_autoloot_theft_los": return "Sichtlinie prüfen (Raycast)";
			case "mod_autoloot_theft_angle": return "Blickwinkel prüfen (100° FOV)";
			case "mod_autoloot_theft_notify": return "Benachrichtigung bei Diebstahl-Überspringung";
			case "mod_autoloot_filter_herbs": return "Kräuter sammeln";
			case "mod_autoloot_filter_corpses": return "Leichen & Monsterreste plündern";
			case "mod_autoloot_filter_chests": return "Aus Kisten und Truhen plündern";
			case "mod_autoloot_filter_containers": return "Aus Säcken, Fässern und Kisten plündern";
			case "mod_autoloot_filter_poi": return "Schatzkisten & Erkundung (PoI)";
			case "mod_autoloot_filter_quest": return "Quest-Gegenstände plündern";
			case "mod_autoloot_filter_equipment": return "Waffen & Rüstungen plündern";
			case "mod_autoloot_ignore_common_equipment": return "Gewöhnliche (weiße) Ausrüstung ignorieren";
			case "mod_autoloot_filter_alchemy": return "Alchemie & Handwerk plündern";
			case "mod_autoloot_filter_books": return "Bücher & Dokumente plündern";
			case "mod_autoloot_filter_junk": return "Krempel / Schrott plündern";
			case "mod_autoloot_filter_money": return "Kronen & Münzen plündern";
			case "mod_autoloot_combat": return "Im Kampf deaktivieren";
			case "mod_autoloot_horse": return "Zu Pferd deaktivieren";
			case "mod_autoloot_weight": return "Überlastungsschutz (Stopp bei Übergewicht)";
			case "mod_autoloot_instant_interact": return "Sofortiges Plündern bei Interaktion";
			case "mod_autoloot_sound": return "Plünder-Sound abspielen";
			case "mod_autoloot_herb_anim": return "Kräutersammel-Animation";
		}
	}
	else if ( lang == "RU" )
	{
		switch ( key )
		{
			case "mods": return "Моды";
			case "panel_mods": return "Моды";
			case "option_mods": return "Моды";
			case "mod_autoloot_group": return "AutoLoot";
			case "mod_autoloot_enabled": return "Включить Автолут";
			case "mod_autoloot_mode": return "Режим сбора";
			case "mod_autoloot_mode_both": return "В радиусе + при взаимодействии";
			case "mod_autoloot_mode_passive": return "Только пассивный в радиусе";
			case "mod_autoloot_mode_interact": return "Одиночный при взаимодействии";
			case "mod_autoloot_mode_interact_aoe": return "Область (AoE) при взаимодействии";
			case "mod_autoloot_passive_herbs": return "Пассивный сбор трав (фоновый)";
			case "mod_autoloot_radius": return "Радиус сбора (метры)";
			case "mod_autoloot_custom_radii": return "Отдельные радиусы по категориям";
			case "mod_autoloot_radius_herbs": return "Радиус: Травы и растения (м)";
			case "mod_autoloot_radius_corpses": return "Радиус: Трупы и монстры (м)";
			case "mod_autoloot_radius_containers": return "Радиус: Сундуки и контейнеры (м)";
			case "mod_autoloot_interval": return "Интервал сканирования";
			case "mod_autoloot_hud_style": return "Уведомления о добыче (HUD)";
			case "mod_autoloot_hud_bottom_right": return "Иконки в правом нижнем углу";
			case "mod_autoloot_hud_bottom_left": return "Иконки в левом нижнем углу";
			case "mod_autoloot_hud_minimal": return "Только текст снизу";
			case "mod_autoloot_hud_off": return "Отключено (Без уведомлений)";
			case "mod_autoloot_hud_right_center": return "Справа в центре (Зона окна добычи)";
			case "mod_autoloot_hud_box": return "Темное окно добычи (Игровой бокс)";
			case "mod_autoloot_hud_scale": return "Лента HUD: Размер элементов (%)";
			case "mod_autoloot_hud_opacity": return "Лента HUD: Прозрачность (%)";
			case "mod_autoloot_hud_group": return "Интерфейс: объединять одинаковые предметы";
			case "mod_autoloot_hud_herbs": return "HUD: Показывать травы";
			case "mod_autoloot_hud_equipment": return "HUD: Показывать оружие и броню";
			case "mod_autoloot_hud_alchemy": return "HUD: Показывать алхимию и ремесло";
			case "mod_autoloot_hud_books": return "HUD: Показывать книги и документы";
			case "mod_autoloot_hud_junk": return "HUD: Показывать мусор";
			case "mod_autoloot_hud_money": return "HUD: Показывать деньги";
			case "mod_autoloot_theft_mode": return "Защита от кражи и стражи";
			case "mod_autoloot_theft_smart": return "Умный (Пропускать, если видят и есть последствия)";
			case "mod_autoloot_theft_never": return "Никогда не красть (Пропускать чужое)";
			case "mod_autoloot_theft_strict": return "Строгий (Пропускать, если стражник рядом)";
			case "mod_autoloot_theft_always": return "Всегда красть (Игнорировать стражу)";
			case "mod_autoloot_theft_radius": return "Радиус обнаружения стражи (м)";
			case "mod_autoloot_theft_los": return "Проверка линии видимости (сквозь стены)";
			case "mod_autoloot_theft_angle": return "Проверка угла обзора (100° FOV)";
			case "mod_autoloot_theft_notify": return "Оповещение о пропуске кражи";
			case "mod_autoloot_filter_herbs": return "Собирать травы";
			case "mod_autoloot_filter_corpses": return "Собирать с трупов и останков монстров";
			case "mod_autoloot_filter_chests": return "Обыскивать сундуки и сундучки";
			case "mod_autoloot_filter_containers": return "Обыскивать мешки, бочки и ящики";
			case "mod_autoloot_filter_poi": return "Тайники и точки интереса (PoI)";
			case "mod_autoloot_filter_quest": return "Собирать квестовые предметы";
			case "mod_autoloot_filter_equipment": return "Собирать оружие и броню";
			case "mod_autoloot_ignore_common_equipment": return "Игнорировать обычное (белое) снаряжение";
			case "mod_autoloot_filter_alchemy": return "Собирать алхимию и ремесло";
			case "mod_autoloot_filter_books": return "Собирать книги и документы";
			case "mod_autoloot_filter_junk": return "Собирать хлам";
			case "mod_autoloot_filter_money": return "Собирать монеты и кроны";
			case "mod_autoloot_combat": return "Отключать в бою";
			case "mod_autoloot_horse": return "Отключать верхом на лошади";
			case "mod_autoloot_weight": return "Защита от перегруза";
			case "mod_autoloot_instant_interact": return "Мгновенный лут при взаимодействии";
			case "mod_autoloot_sound": return "Звук подбора предметов";
			case "mod_autoloot_herb_anim": return "Анимация сбора трав";
		}
	}
	else if ( lang == "BR" )
	{
		switch ( key )
		{
			case "mods": return "Mods";
			case "panel_mods": return "Mods";
			case "option_mods": return "Mods";
			case "mod_autoloot_group": return "AutoLoot";
			case "mod_autoloot_enabled": return "Ativar AutoLoot";
			case "mod_autoloot_mode": return "Modo de Saque";
			case "mod_autoloot_mode_both": return "Raio de Área + Ao Interagir";
			case "mod_autoloot_mode_passive": return "Apenas Raio Passivo de Área";
			case "mod_autoloot_mode_interact": return "Alvo Único ao Interagir";
			case "mod_autoloot_mode_interact_aoe": return "Área (AoE) ao Interagir";
			case "mod_autoloot_passive_herbs": return "Coleta Passiva de Ervas (em segundo plano)";
			case "mod_autoloot_radius": return "Raio de Saque (metros)";
			case "mod_autoloot_custom_radii": return "Raios Independentes por Categoria";
			case "mod_autoloot_radius_herbs": return "Raio: Ervas e Plantas (m)";
			case "mod_autoloot_radius_corpses": return "Raio: Cadáveres e Monstros (m)";
			case "mod_autoloot_radius_containers": return "Raio: Baús e Recipientes (m)";
			case "mod_autoloot_interval": return "Intervalo de Varredura";
			
			// HUD
			case "mod_autoloot_hud_style": return "Estilo de Notificação (HUD)";
			case "mod_autoloot_hud_bottom_right": return "Ícones no Canto Inferior Direito";
			case "mod_autoloot_hud_bottom_left": return "Ícones no Canto Inferior Esquerdo";
			case "mod_autoloot_hud_minimal": return "Mensagem de Texto Inferior";
			case "mod_autoloot_hud_off": return "Desativado (Saque Silencioso)";
			case "mod_autoloot_hud_right_center": return "Centro-Direita (Área da janela de saque)";
			case "mod_autoloot_hud_box": return "Caixa Escura de Saque (Estilo de Jogo)";
			case "mod_autoloot_hud_scale": return "Feed HUD: Escala dos itens (%)";
			case "mod_autoloot_hud_opacity": return "Feed HUD: Opacidade (%)";
			case "mod_autoloot_hud_group": return "HUD: Agrupar itens idênticos";
			case "mod_autoloot_hud_herbs": return "Feed HUD: Mostrar Ervas";
			case "mod_autoloot_hud_equipment": return "Feed HUD: Mostrar Armas e Armaduras";
			case "mod_autoloot_hud_alchemy": return "Feed HUD: Mostrar Alquimia e Artesanato";
			case "mod_autoloot_hud_books": return "Feed HUD: Mostrar Livros e Documentos";
			case "mod_autoloot_hud_junk": return "Feed HUD: Mostrar Tralhas e Sucata";
			case "mod_autoloot_hud_money": return "Feed HUD: Mostrar Dinheiro";

			// Theft & Guard Protection
			case "mod_autoloot_theft_mode": return "Proteção contra Roubo e Guardas";
			case "mod_autoloot_theft_smart": return "Seguro Inteligente (Ignora se houver consequências)";
			case "mod_autoloot_theft_never": return "Nunca Roubar (Ignorar propriedade alheia)";
			case "mod_autoloot_theft_strict": return "Rigoroso (Ignora se guarda estiver por perto)";
			case "mod_autoloot_theft_always": return "Sempre Roubar (Ignorar guardas e testemunhas)";
			case "mod_autoloot_theft_radius": return "Raio de Detecção de Guardas (m)";
			case "mod_autoloot_theft_los": return "Verificar Linha de Visão de Testemunhas";
			case "mod_autoloot_theft_angle": return "Verificar Ângulo de Visão (100° FOV)";
			case "mod_autoloot_theft_notify": return "Notificar quando roubo for ignorado";
			
			// Sources
			case "mod_autoloot_filter_herbs": return "Saquear Ervas";
			case "mod_autoloot_filter_corpses": return "Saquear Cadáveres e Monstros";
			case "mod_autoloot_filter_chests": return "Saquear baús e cofres";
			case "mod_autoloot_filter_containers": return "Saquear sacos, barris e engradados";
			case "mod_autoloot_filter_poi": return "Saquear Baús de Exploração (PdI)";
			case "mod_autoloot_filter_quest": return "Saquear Itens de Missão";
			
			// Categories
			case "mod_autoloot_filter_equipment": return "Saquear Armas e Armaduras";
			case "mod_autoloot_ignore_common_equipment": return "Ignorar equipamentos comuns (brancos)";
			case "mod_autoloot_filter_alchemy": return "Saquear Alquimia e Artesanato";
			case "mod_autoloot_filter_books": return "Saquear Livros e Documentos";
			case "mod_autoloot_filter_junk": return "Saquear Tralhas e Sucata";
			case "mod_autoloot_filter_money": return "Saquear Dinheiro / Moedas";
			
			// Conditions
			case "mod_autoloot_combat": return "Desativar em Combate";
			case "mod_autoloot_horse": return "Desativar a Cavalo";
			case "mod_autoloot_weight": return "Verificação de Peso (Parar se sobrecarregado)";
			case "mod_autoloot_instant_interact": return "Saque Imediato ao Interagir (Pular Janela)";
			case "mod_autoloot_sound": return "Tocar Som de Saque";
			case "mod_autoloot_herb_anim": return "Animação ao coletar ervas";
		}
	}
	else if ( lang == "FR" )
	{
		switch ( key )
		{
			case "mods": return "Mods";
			case "panel_mods": return "Mods";
			case "option_mods": return "Mods";
			case "mod_autoloot_group": return "AutoLoot";
			case "mod_autoloot_enabled": return "Activer AutoLoot";
			case "mod_autoloot_mode": return "Mode de pillage";
			case "mod_autoloot_mode_both": return "Rayon de zone + à l'interaction";
			case "mod_autoloot_mode_passive": return "Rayon passif uniquement";
			case "mod_autoloot_mode_interact": return "Cible unique à l'interaction";
			case "mod_autoloot_mode_interact_aoe": return "Zone (AoE) à l'interaction";
			case "mod_autoloot_passive_herbs": return "Récolte passive des herbes (en arrière-plan)";
			case "mod_autoloot_radius": return "Rayon de pillage (mètres)";
			case "mod_autoloot_custom_radii": return "Rayons indépendants par catégorie";
			case "mod_autoloot_radius_herbs": return "Rayon : Herbes et plantes (m)";
			case "mod_autoloot_radius_corpses": return "Rayon : Cadavres et monstres (m)";
			case "mod_autoloot_radius_containers": return "Rayon : Coffres et récipients (m)";
			case "mod_autoloot_interval": return "Intervalle de détection";
			
			// HUD
			case "mod_autoloot_hud_style": return "Style de notification (HUD)";
			case "mod_autoloot_hud_bottom_right": return "Icônes en bas à droite";
			case "mod_autoloot_hud_bottom_left": return "Icônes en bas à gauche";
			case "mod_autoloot_hud_minimal": return "Message textuel en bas";
			case "mod_autoloot_hud_off": return "Désactivé (Pillage silencieux)";
			case "mod_autoloot_hud_right_center": return "Centre-Droit (Zone de la fenêtre de butin)";
			case "mod_autoloot_hud_box": return "Fenêtre de butin sombre (Boîte)";
			case "mod_autoloot_hud_scale": return "Flux HUD: Échelle des éléments (%)";
			case "mod_autoloot_hud_opacity": return "Flux HUD: Opacité (%)";
			case "mod_autoloot_hud_group": return "HUD : Grouper les objets identiques";
			case "mod_autoloot_hud_herbs": return "HUD: Afficher les herbes";
			case "mod_autoloot_hud_equipment": return "HUD: Afficher armes et armures";
			case "mod_autoloot_hud_alchemy": return "HUD: Afficher alchimie et artisanat";
			case "mod_autoloot_hud_books": return "HUD: Afficher livres et documents";
			case "mod_autoloot_hud_junk": return "HUD: Afficher le bric-à-brac";
			case "mod_autoloot_hud_money": return "HUD: Afficher l'argent";

			// Theft & Guard Protection
			case "mod_autoloot_theft_mode": return "Protection contre le vol et gardes";
			case "mod_autoloot_theft_smart": return "Prudent intelligent (Ignorer si témoins & conséquences)";
			case "mod_autoloot_theft_never": return "Ne jamais voler (Ignorer toute propriété gardée)";
			case "mod_autoloot_theft_strict": return "Strict (Ignorer si un garde est proche)";
			case "mod_autoloot_theft_always": return "Toujours voler (Ignorer les gardes)";
			case "mod_autoloot_theft_radius": return "Rayon de détection des gardes (m)";
			case "mod_autoloot_theft_los": return "Vérifier la ligne de mire des témoins";
			case "mod_autoloot_theft_angle": return "Vérifier l'angle de vision (100° FOV)";
			case "mod_autoloot_theft_notify": return "Notification lors d'un vol ignoré";
			
			// Sources
			case "mod_autoloot_filter_herbs": return "Piller les herbes";
			case "mod_autoloot_filter_corpses": return "Piller les cadavres et restes de monstres";
			case "mod_autoloot_filter_chests": return "Piller les coffres et malles";
			case "mod_autoloot_filter_containers": return "Piller les sacs, tonneaux et caisses";
			case "mod_autoloot_filter_poi": return "Piller les caches d'exploration (PoI)";
			case "mod_autoloot_filter_quest": return "Piller les objets de quête";
			
			// Categories
			case "mod_autoloot_filter_equipment": return "Piller armes et armures";
			case "mod_autoloot_ignore_common_equipment": return "Ignorer l'équipement commun (blanc)";
			case "mod_autoloot_filter_alchemy": return "Piller alchimie et artisanat";
			case "mod_autoloot_filter_books": return "Piller livres et documents";
			case "mod_autoloot_filter_junk": return "Piller le bric-à-brac";
			case "mod_autoloot_filter_money": return "Piller l'argent / couronnes";
			
			// Conditions
			case "mod_autoloot_combat": return "Désactiver en combat";
			case "mod_autoloot_horse": return "Désactiver à cheval";
			case "mod_autoloot_weight": return "Contrôle d'encombrement (Arrêter si surchargé)";
			case "mod_autoloot_instant_interact": return "Pillage immédiat à l'interaction (Sans fenêtre)";
			case "mod_autoloot_sound": return "Jouer le son de pillage";
			case "mod_autoloot_herb_anim": return "Animation de récolte des herbes";
		}
	}
	else if ( lang == "ZH" )
	{
		switch ( key )
		{
			case "mods": return "模组";
			case "panel_mods": return "模组";
			case "option_mods": return "模组";
			case "mod_autoloot_group": return "AutoLoot";
			case "mod_autoloot_enabled": return "启用 AutoLoot";
			case "mod_autoloot_mode": return "拾取模式";
			case "mod_autoloot_mode_both": return "范围拾取 + 互动拾取";
			case "mod_autoloot_mode_passive": return "持续范围拾取 (被动)";
			case "mod_autoloot_mode_interact": return "单体互动拾取";
			case "mod_autoloot_mode_interact_aoe": return "互动时范围拾取 (AoE)";
			case "mod_autoloot_passive_herbs": return "被动采集草药 (后台)";
			case "mod_autoloot_radius": return "拾取范围 (米)";
			case "mod_autoloot_custom_radii": return "按分类独立设置范围";
			case "mod_autoloot_radius_herbs": return "范围: 草药和植物 (米)";
			case "mod_autoloot_radius_corpses": return "范围: 尸体和怪物 (米)";
			case "mod_autoloot_radius_containers": return "范围: 宝箱和容器 (米)";
			case "mod_autoloot_interval": return "扫描频率";
			
			// HUD
			case "mod_autoloot_hud_style": return "拾取提示样式 (HUD)";
			case "mod_autoloot_hud_bottom_right": return "右下角物品卡片";
			case "mod_autoloot_hud_bottom_left": return "左下角物品卡片";
			case "mod_autoloot_hud_minimal": return "底部极简文本";
			case "mod_autoloot_hud_off": return "关闭 (静默拾取)";
			case "mod_autoloot_hud_right_center": return "右侧居中 (开阔区域)";
			case "mod_autoloot_hud_box": return "深色拾取窗口 (游戏原生框)";
			case "mod_autoloot_hud_scale": return "HUD提示: 图标与卡片缩放 (%)";
			case "mod_autoloot_hud_opacity": return "HUD提示: 不透明度 (%)";
			case "mod_autoloot_hud_group": return "HUD提示: 合并相同物品";
			case "mod_autoloot_hud_herbs": return "HUD提示: 显示草药";
			case "mod_autoloot_hud_equipment": return "HUD提示: 显示武器与护甲";
			case "mod_autoloot_hud_alchemy": return "HUD提示: 显示炼金与材料";
			case "mod_autoloot_hud_books": return "HUD提示: 显示书籍与文档";
			case "mod_autoloot_hud_junk": return "HUD提示: 显示杂物垃圾";
			case "mod_autoloot_hud_money": return "HUD提示: 显示货币与克朗";

			// Theft
			case "mod_autoloot_theft_mode": return "防偷窃保护";
			case "mod_autoloot_theft_smart": return "智能 (有人目击且有后果时跳过)";
			case "mod_autoloot_theft_never": return "从不偷窃 (跳过所有他人财物)";
			case "mod_autoloot_theft_strict": return "谨慎 (守卫在附近时跳过)";
			case "mod_autoloot_theft_always": return "总是偷窃 (无视守卫和目击者)";
			case "mod_autoloot_theft_radius": return "守卫/目击者警戒范围 (米)";
			case "mod_autoloot_theft_los": return "检查目击者视线 (LoS)";
			case "mod_autoloot_theft_angle": return "检查目击者视野角度 (100度视角)";
			case "mod_autoloot_theft_notify": return "跳过偷窃时显示提示";
			
			// Sources
			case "mod_autoloot_filter_herbs": return "拾取草药";
			case "mod_autoloot_filter_corpses": return "拾取尸体与怪物残骸";
			case "mod_autoloot_filter_chests": return "搜刮宝箱与箱子";
			case "mod_autoloot_filter_containers": return "搜刮麻袋、木桶与木箱";
			case "mod_autoloot_filter_poi": return "拾取探索宝藏 (PoI)";
			case "mod_autoloot_filter_quest": return "拾取任务物品";
			
			// Categories
			case "mod_autoloot_filter_equipment": return "拾取武器与护甲";
			case "mod_autoloot_ignore_common_equipment": return "忽略普通 (白色) 武器与护甲";
			case "mod_autoloot_filter_alchemy": return "拾取炼金与制作材料";
			case "mod_autoloot_filter_books": return "拾取书籍与文档";
			case "mod_autoloot_filter_junk": return "拾取杂物 (垃圾)";
			case "mod_autoloot_filter_money": return "拾取克朗与货币";
			
			// Conditions
			case "mod_autoloot_combat": return "战斗中禁用";
			case "mod_autoloot_horse": return "骑马时禁用";
			case "mod_autoloot_weight": return "负重检查 (超重时停止拾取)";
			case "mod_autoloot_instant_interact": return "互动时立即拾取 (跳过窗口)";
			case "mod_autoloot_sound": return "播放拾取音效";
			case "mod_autoloot_herb_anim": return "采药动作动画";
		}
	}
	else if ( lang == "ZT" )
	{
		switch ( key )
		{
			case "mods": return "模組";
			case "panel_mods": return "模組";
			case "option_mods": return "模組";
			case "mod_autoloot_group": return "AutoLoot";
			case "mod_autoloot_enabled": return "啟用 AutoLoot";
			case "mod_autoloot_mode": return "拾取模式";
			case "mod_autoloot_mode_both": return "範圍拾取 + 互動拾取";
			case "mod_autoloot_mode_passive": return "持續範圍拾取 (被動)";
			case "mod_autoloot_mode_interact": return "單體互動拾取";
			case "mod_autoloot_mode_interact_aoe": return "互動時範圍拾取 (AoE)";
			case "mod_autoloot_passive_herbs": return "被動採集草藥 (背景)";
			case "mod_autoloot_radius": return "拾取範圍 (公尺)";
			case "mod_autoloot_custom_radii": return "按分類獨立設置範圍";
			case "mod_autoloot_radius_herbs": return "範圍: 草藥和植物 (公尺)";
			case "mod_autoloot_radius_corpses": return "範圍: 屍體和怪物 (公尺)";
			case "mod_autoloot_radius_containers": return "範圍: 寶箱和容器 (公尺)";
			case "mod_autoloot_interval": return "掃描頻率";
			
			// HUD
			case "mod_autoloot_hud_style": return "拾取提示樣式 (HUD)";
			case "mod_autoloot_hud_bottom_right": return "右下角物品卡片";
			case "mod_autoloot_hud_bottom_left": return "左下角物品卡片";
			case "mod_autoloot_hud_minimal": return "底部極簡文字";
			case "mod_autoloot_hud_off": return "關閉 (靜默拾取)";
			case "mod_autoloot_hud_right_center": return "右側畫面邊緣 (開闊區域)";
			case "mod_autoloot_hud_box": return "深色拾取視窗 (遊戲原生框)";
			case "mod_autoloot_hud_scale": return "HUD提示: 圖標與卡片縮放 (%)";
			case "mod_autoloot_hud_opacity": return "HUD提示: 不透明度 (%)";
			case "mod_autoloot_hud_group": return "HUD提示: 合併相同物品";
			case "mod_autoloot_hud_herbs": return "HUD提示: 顯示草藥";
			case "mod_autoloot_hud_equipment": return "HUD提示: 顯示武器與護甲";
			case "mod_autoloot_hud_alchemy": return "HUD提示: 顯示煉金與材料";
			case "mod_autoloot_hud_books": return "HUD提示: 顯示書籍與文件";
			case "mod_autoloot_hud_junk": return "HUD提示: 顯示雜物垃圾";
			case "mod_autoloot_hud_money": return "HUD提示: 顯示貨幣與克朗";

			// Theft
			case "mod_autoloot_theft_mode": return "防偷竊保護";
			case "mod_autoloot_theft_smart": return "智慧 (有人目擊且有後果時略過)";
			case "mod_autoloot_theft_never": return "從不偷竊 (略過所有他人財物)";
			case "mod_autoloot_theft_strict": return "謹慎 (守衛在附近時略過)";
			case "mod_autoloot_theft_always": return "總是偷竊 (無視守衛與目擊者)";
			case "mod_autoloot_theft_radius": return "守衛/目擊者警戒範圍 (公尺)";
			case "mod_autoloot_theft_los": return "檢查目擊者視線 (LoS)";
			case "mod_autoloot_theft_angle": return "檢查目擊者視野角度 (100度視角)";
			case "mod_autoloot_theft_notify": return "略過偷竊時顯示提示";
			
			// Sources
			case "mod_autoloot_filter_herbs": return "拾取草藥";
			case "mod_autoloot_filter_corpses": return "拾取屍體與怪物殘骸";
			case "mod_autoloot_filter_chests": return "搜刮寶箱與箱子";
			case "mod_autoloot_filter_containers": return "搜刮麻袋、木桶與木箱";
			case "mod_autoloot_filter_poi": return "拾取探索寶藏 (PoI)";
			case "mod_autoloot_filter_quest": return "拾取任務物品";
			
			// Categories
			case "mod_autoloot_filter_equipment": return "拾取武器與護甲";
			case "mod_autoloot_ignore_common_equipment": return "忽略普通 (白色) 武器與護甲";
			case "mod_autoloot_filter_alchemy": return "拾取煉金與製作材料";
			case "mod_autoloot_filter_books": return "拾取書籍與文件";
			case "mod_autoloot_filter_junk": return "拾取雜物 (垃圾)";
			case "mod_autoloot_filter_money": return "拾取克朗與貨幣";
			
			// Conditions
			case "mod_autoloot_combat": return "戰鬥中禁用";
			case "mod_autoloot_horse": return "騎馬時禁用";
			case "mod_autoloot_weight": return "負重檢查 (超重時停止拾取)";
			case "mod_autoloot_instant_interact": return "互動時立即拾取 (跳過視窗)";
			case "mod_autoloot_sound": return "播放拾取音效";
			case "mod_autoloot_herb_anim": return "採藥動作動畫";
		}
	}
	else
	{
		// Default English
		switch ( key )
		{
			case "mods": return "Mods";
			case "panel_mods": return "Mods";
			case "option_mods": return "Mods";
			case "mod_autoloot_group": return "AutoLoot";
			case "mod_autoloot_enabled": return "Enable AutoLoot";
			case "mod_autoloot_mode": return "Looting Mode";
			case "mod_autoloot_mode_both": return "Area Radius + On Interaction";
			case "mod_autoloot_mode_passive": return "Passive Area Radius Only";
			case "mod_autoloot_mode_interact": return "Single Target on Interaction";
			case "mod_autoloot_mode_interact_aoe": return "Area (AoE) on Interaction Only";
			case "mod_autoloot_passive_herbs": return "Passive Herb Harvesting (Background)";
			case "mod_autoloot_radius": return "Looting Radius (meters)";
			case "mod_autoloot_custom_radii": return "Independent Category Radii";
			case "mod_autoloot_radius_herbs": return "Radius: Herbs and Plants (m)";
			case "mod_autoloot_radius_corpses": return "Radius: Corpses and Monsters (m)";
			case "mod_autoloot_radius_containers": return "Radius: Chests and Containers (m)";
			case "mod_autoloot_interval": return "Scan Interval";
			
			// HUD
			case "mod_autoloot_hud_style": return "Loot Notification Style (HUD)";
			case "mod_autoloot_hud_bottom_right": return "Icons in Bottom-Right Corner";
			case "mod_autoloot_hud_bottom_left": return "Icons in Bottom-Left Corner";
			case "mod_autoloot_hud_minimal": return "Text Message at Bottom";
			case "mod_autoloot_hud_off": return "Disabled (Silent Looting)";
			case "mod_autoloot_hud_right_center": return "Right-Center (Loot Window Area)";
			case "mod_autoloot_hud_box": return "Dark Loot Window (Game Box)";
			case "mod_autoloot_hud_scale": return "HUD Feed: Item Scale (%)";
			case "mod_autoloot_hud_opacity": return "HUD Feed: Opacity (%)";
			case "mod_autoloot_hud_group": return "HUD Feed: Group Identical Items";
			case "mod_autoloot_hud_herbs": return "HUD Feed: Show Herbs";
			case "mod_autoloot_hud_equipment": return "HUD Feed: Show Weapons & Armor";
			case "mod_autoloot_hud_alchemy": return "HUD Feed: Show Alchemy & Crafting";
			case "mod_autoloot_hud_books": return "HUD Feed: Show Books & Documents";
			case "mod_autoloot_hud_junk": return "HUD Feed: Show Junk & Clutter";
			case "mod_autoloot_hud_money": return "HUD Feed: Show Money / Coins";

			// Theft & Guard Protection
			case "mod_autoloot_theft_mode": return "Theft & Guard Protection";
			case "mod_autoloot_theft_smart": return "Smart Safe (Skip if witnessed with consequences)";
			case "mod_autoloot_theft_never": return "Never Steal (Skip all guarded property)";
			case "mod_autoloot_theft_strict": return "Strict (Skip if guard is nearby)";
			case "mod_autoloot_theft_always": return "Always Steal (Ignore guards & consequences)";
			case "mod_autoloot_theft_radius": return "Guard & Witness Detection Radius (m)";
			case "mod_autoloot_theft_los": return "Check Line of Sight for Witnesses";
			case "mod_autoloot_theft_angle": return "Check Witness Facing Angle (100° FOV)";
			case "mod_autoloot_theft_notify": return "Notify when theft skipped due to guards";
			
			// Sources
			case "mod_autoloot_filter_herbs": return "Loot Herbs";
			case "mod_autoloot_filter_corpses": return "Loot Corpses & Monster Remains";
			case "mod_autoloot_filter_chests": return "Loot Chests and Coffers";
			case "mod_autoloot_filter_containers": return "Loot Sacks, Barrels & Crates";
			case "mod_autoloot_filter_poi": return "Loot Exploration Caches & PoIs";
			case "mod_autoloot_filter_quest": return "Loot Quest Items";
			
			// Categories
			case "mod_autoloot_filter_equipment": return "Loot Weapons & Armor";
			case "mod_autoloot_ignore_common_equipment": return "Ignore Common (White) Gear";
			case "mod_autoloot_filter_alchemy": return "Loot Alchemy & Crafting Items";
			case "mod_autoloot_filter_books": return "Loot Books & Documents";
			case "mod_autoloot_filter_junk": return "Loot Junk & Clutter";
			case "mod_autoloot_filter_money": return "Loot Money / Coins";
			
			// Conditions
			case "mod_autoloot_combat": return "Disable in Combat";
			case "mod_autoloot_horse": return "Disable on Horseback";
			case "mod_autoloot_weight": return "Encumbrance Check (Stop if overweight)";
			case "mod_autoloot_instant_interact": return "Instant Loot on Interaction (Skip Window)";
			case "mod_autoloot_sound": return "Play Loot Sound";
			case "mod_autoloot_herb_anim": return "Herb Gathering Animation";
		}
	}

	if ( key == "0.3s" || key == "0.5s" || key == "1.0s" || key == "1.5s" || key == "2.0s" )
	{
		return key;
	}

	return "";
}
