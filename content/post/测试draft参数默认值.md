---
title: "{{ replace .TranslationBaseName "-" " " | title }}"
date: {{ .Date }}
lastmod: {{ .Date }}

keywords: [关键字]
description: ""
tags: [ 测试标签 ]
categories: [ 测试分类 ]
author: "平阳"

---

测试不加draft参数，看看默认是true还是false