﻿
&НаСервере
Процедура ЗаполнитьОстаткамиНаСервере()

	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	НачатьТранзакцию();
	УчетнаяПолитикаТекущая = УчетнаяПолитикаСервер.ПолучитьТекущуюУчетнуюПолитику(Объект.Дата);
	УчетнаяПолитикаПрошлая = УчетнаяПолитикаСервер.ПолучитьТекущуюУчетнуюПолитику(НачалоДня(ОБъект.Дата) - 1);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОстаткиНоменклатурыОстатки.Склад КАК Склад,
		|	ОстаткиНоменклатурыОстатки.Номенклатура КАК Номенклатура,
		|	ОстаткиНоменклатурыОстатки.Партия КАК Партия,
		|	ОстаткиНоменклатурыОстатки.КоличествоОстаток КАК Количество,
		|	ОстаткиНоменклатурыОстатки.СуммаОстаток КАК Сумма
		|ИЗ
		|	РегистрНакопления.ОстаткиНоменклатуры.Остатки(&Дата, ) КАК ОстаткиНоменклатурыОстатки";
	
	Запрос.УстановитьПараметр("Дата", Новый Граница(НачалоДня(ОБъект.Дата) - 1));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		СТрокаДвиженияРасход = Объект.Движения.ОстаткиНоменклатуры.Добавить();
		ЗаполнитьЗначенияСвойств(СТрокаДвиженияРасход, ВыборкаДетальныеЗаписи);
		
		СТрокаДвиженияРасход.Период = НачалоДня(ОБъект.Дата) - 1;
		СТрокаДвиженияРасход.ВидДвижения = ВидДвиженияНакопления.Расход;
		СТрокаДвиженияРасход.Активность = Истина;
		
		СТрокаДвиженияПриход = Объект.Движения.ОстаткиНоменклатуры.Добавить();
		ЗаполнитьЗначенияСвойств(СТрокаДвиженияПриход, ВыборкаДетальныеЗаписи);
		
		СТрокаДвиженияПриход.Период = НачалоДня(ОБъект.Дата) - 1;
		СТрокаДвиженияПриход.ВидДвижения = ВидДвиженияНакопления.Приход;
		СТрокаДвиженияПриход.Активность = Истина;
		
		Если НЕ УчетнаяПолитикаТекущая = УчетнаяПолитикаПрошлая Тогда 
			Средняя = ПредопределенноеЗначение("Перечисление.УчетнаяПолитика.Средняя");  
			Если УчетнаяПолитикаТекущая = Средняя Тогда
				
				СтрокаДвиженияПриход.Партия = Неопределено;
				
			ИначеЕсли УчетнаяПолитикаПрошлая = Средняя Тогда
				
				
				СТрокаДвиженияРасход.Партия = Неопределено;
				СтрокаДвиженияПриход.Партия = Объект.Ссылка;
			
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОстатками(Команда)
	 ЗаполнитьОстаткамиНаСервере();
КонецПроцедуры
