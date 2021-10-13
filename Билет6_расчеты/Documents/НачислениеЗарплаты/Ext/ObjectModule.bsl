﻿
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если НЕ ЗначениеЗаполнено(ПериодРегистрации) Тогда
		ПериодРегистрации = Дата;
	КонецЕсли;
	
	ПериодРегистрации = НачалоМесяца(ПериодРегистрации);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	
	Движения.ОсновныеНачисления.Записывать = Истина;
	Движения.ДополнительныеНачисления.Записывать = Истина;
	
	Для Каждого ТекСтрокаОсновныеНачисления Из ОсновныеНачисления Цикл
		
		Движение = Движения.ОсновныеНачисления.Добавить();
		Движение.Сторно = Ложь;
		Движение.ВидРасчета = ТекСтрокаОсновныеНачисления.ВидРасчета;
		Движение.ПериодДействияНачало = ТекСтрокаОсновныеНачисления.ДатаНачала;
		Движение.ПериодДействияКонец = КонецДня(ТекСтрокаОсновныеНачисления.ДатаОкончания);
		Движение.ПериодРегистрации = ПериодРегистрации;
		Движение.Сотрудник = ТекСтрокаОсновныеНачисления.Сотрудник;
		
		Если Движение.ВидРасчета = ПланыВидовРасчета.ОсновныеНачисления.Отпуск Тогда
			
			Движение.Автомобиль = Справочники.Автомобили.ШаблонПятидневка;
			Движение.БазовыйПериодНачало = ДобавитьМесяц(ПериодРегистрации, -3);
			Движение.БазовыйПериодКонец = ПериодРегистрации-1;
			
		Иначе
			
			Движение.Автомобиль = ТекСтрокаОсновныеНачисления.Автомобиль;
			
		КонецЕсли;
		
	КонецЦикла;

	КонстантаСумма = Константы.ФиксированнаяСумма.Получить();
	Для Каждого ТекСтрокаДополнительныеНачисления Из ДополнительныеНачисления Цикл
		
		Движение = Движения.ДополнительныеНачисления.Добавить();
		Движение.Сторно = Ложь;
		Движение.ВидРасчета = ТекСтрокаДополнительныеНачисления.ВидРасчета;
		Движение.ПериодРегистрации = ПериодРегистрации;
		Движение.Сотрудник = ТекСтрокаДополнительныеНачисления.Сотрудник;
		Движение.Автомобиль = ТекСтрокаДополнительныеНачисления.Автомобиль;
		Если Движение.ВидРасчета = ПланыВидовРасчета.ДополнительныеНачисления.ФиксированнаяСумма Тогда
			Движение.Результат = КонстантаСумма;
		КонецЕсли;
		
	КонецЦикла;

	Движения.Записать();
	
	РассчитатьНадбавку();
	РассчитатьОтпуск();
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
КонецПроцедуры

Процедура РассчитатьНадбавку()
	
		//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДополнительныеНачисления.Сотрудник КАК Сотрудник,
		|	ДополнительныеНачисления.Автомобиль КАК Автомобиль,
		|	ДополнительныеНачисления.НомерСтроки КАК НомерСтроки
		|ПОМЕСТИТЬ ВТ_ДанныеНачислений
		|ИЗ
		|	РегистрРасчета.ДополнительныеНачисления КАК ДополнительныеНачисления
		|ГДЕ
		|	ДополнительныеНачисления.Регистратор = &Регистратор
		|	И ДополнительныеНачисления.ВидРасчета = &ВидРасчетаНадбавка
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Сотрудник,
		|	Автомобиль
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ДанныеНачислений.НомерСтроки КАК НомерСтроки,
		|	ЕСТЬNULL(ОплатаОтПассажировОбороты.СуммаОборот, 0) КАК СуммаОплат,
		|	ЕСТЬNULL(ПроцентНадбавкиСрезПоследних.ПроцентНадбавки, 0) КАК ПроцентНадбавки
		|ИЗ
		|	ВТ_ДанныеНачислений КАК ВТ_ДанныеНачислений
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ОплатаОтПассажиров.Обороты(
		|				&ПрошлыйМесяцНачало,
		|				&ПрошлыйМесяцКонец,
		|				,
		|				(Сотрудник, Автомобиль) В
		|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|						ВТ_ДанныеНачислений.Сотрудник КАК Сотрудник,
		|						ВТ_ДанныеНачислений.Автомобиль КАК Автомобиль
		|					ИЗ
		|						ВТ_ДанныеНачислений КАК ВТ_ДанныеНачислений)) КАК ОплатаОтПассажировОбороты
		|		ПО ВТ_ДанныеНачислений.Сотрудник = ОплатаОтПассажировОбороты.Сотрудник
		|			И ВТ_ДанныеНачислений.Автомобиль = ОплатаОтПассажировОбороты.Автомобиль
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПроцентНадбавки.СрезПоследних КАК ПроцентНадбавкиСрезПоследних
		|		ПО (ИСТИНА)";
	
	Запрос.УстановитьПараметр("ВидРасчетаНадбавка", ПланыВидовРасчета.ДополнительныеНачисления.Надбавка);
	Запрос.УстановитьПараметр("ПрошлыйМесяцКонец", ПериодРегистрации - 1);
	Запрос.УстановитьПараметр("ПрошлыйМесяцНачало", ДобавитьМесяц(ПериодРегистрации, -1));
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Для Каждого Движение из Движения.ДополнительныеНачисления Цикл
		
		Если Движение.ВидРасчета <> ПланыВидовРасчета.ДополнительныеНачисления.Надбавка Тогда
		
			Продолжить;
		
		КонецЕсли;
		
		ВыборкаДетальныеЗаписи.Сбросить();
		Если ВыборкаДетальныеЗаписи.НайтиСледующий(Движение.НомерСтроки, "НомерСтроки") Тогда
			
			Движение.Параметр1 = ВыборкаДетальныеЗаписи.ПроцентНадбавки;
			Движение.Параметр2 = ВыборкаДетальныеЗаписи.СуммаОплат;
			
			Движение.Результат = ВыборкаДетальныеЗаписи.СуммаОплат * ВыборкаДетальныеЗаписи.ПроцентНадбавки / 100;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Движения.ДополнительныеНачисления.Записать();
	
КонецПроцедуры

Процедура РассчитатьОтпуск()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОсновныеНачисленияДанныеГрафика.НомерСтроки КАК НомерСтроки,
	|	ОсновныеНачисленияДанныеГрафика.ЗначениеБазовыйПериод КАК ДнейБазаПлан,
	|	ОсновныеНачисленияДанныеГрафика.ЗначениеФактическийПериодДействия КАК ДнейФакт,
	|	ЕСТЬNULL(ОсновныеНачисленияБазаОсновныеНачисления.РезультатБаза, 0) КАК ОснНачисленияСумма,
	|	ЕСТЬNULL(ОсновныеНачисленияБазаДополнительныеНачисления.РезультатБаза, 0) КАК ДопНачисленияСумма
	|ИЗ
	|	РегистрРасчета.ОсновныеНачисления.ДанныеГрафика(Регистратор = &Регистратор) КАК ОсновныеНачисленияДанныеГрафика
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ОсновныеНачисления.БазаОсновныеНачисления(&Измерения, &Измерения, , Регистратор = &Регистратор) КАК ОсновныеНачисленияБазаОсновныеНачисления
	|		ПО ОсновныеНачисленияДанныеГрафика.НомерСтроки = ОсновныеНачисленияБазаОсновныеНачисления.НомерСтроки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ОсновныеНачисления.БазаДополнительныеНачисления(&Измерения, &Измерения, , Регистратор = &Регистратор) КАК ОсновныеНачисленияБазаДополнительныеНачисления
	|		ПО ОсновныеНачисленияДанныеГрафика.НомерСтроки = ОсновныеНачисленияБазаДополнительныеНачисления.НомерСтроки";
	
	Измерения = Новый Массив;
	Измерения.Добавить("Сотрудник");
	Запрос.УстановитьПараметр("Измерения", Измерения);
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Для Каждого Движение из Движения.ОсновныеНачисления Цикл
		
		Если Движение.ВидРасчета <> ПланыВидовРасчета.ОсновныеНачисления.Отпуск Тогда
		
			Продолжить;
		
		КонецЕсли;
		
		ВыборкаДетальныеЗаписи.Сбросить();
		Если ВыборкаДетальныеЗаписи.НайтиСледующий(Движение.НомерСтроки, "НомерСтроки") Тогда
			
			Движение.Параметр1 = ВыборкаДетальныеЗаписи.ДнейФакт;
			Движение.Параметр2 = ВыборкаДетальныеЗаписи.ОснНачисленияСумма + ВыборкаДетальныеЗаписи.ДопНачисленияСумма;
			Движение.Параметр3 = ВыборкаДетальныеЗаписи.ДнейБазаПлан;
			
			Если Движение.Параметр3 <> 0 Тогда
				Движение.Результат = Движение.Параметр2 / Движение.Параметр3 * Движение.Параметр1;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Движения.ОсновныеНачисления.Записать();
	
КонецПроцедуры

