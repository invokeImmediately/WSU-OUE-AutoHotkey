﻿class Trie {
	_children := Object()
	_node := ""
	_isEndOfWord := False

	__New(key, isEndOfWord) {
		this._node := key
		this._isEndOfWord := isEndOfWord
	}

	Insert(key) {
		length := StrLen(key)
		subTrie := this
		Loop, %length%
		{
			subKey := SubStr(key, 1, A_Index)
			isEndOfWord := A_Index == length
			child := (subTrie.children)[subKey]
			if (!child) {
				(subTrie.children)[subKey] := New Trie(subKey, isEndOfWord)
				subTrie := (subTrie.children)[subKey]
			} else {
				subTrie := child
				if (A_Index == length) {
					subTrie.isEndOfWord := True
				}
			}
		}
	}

	Search(key) {
		; Find a node within the trie
		length := StrLen(key)
		subTrie := this
		child := False
		Loop, %length%
		{
			subKey := SubStr(key, 1, A_Index)
			child := (subTrie.children)[subKey]
			if (!child) {
				Break
			} else {
				subTrie := child
			}
		}
		Return child
	}

	CalculateWordCount(key := "") {
		wordCount := 0
		if (key == "" || key == this.node) {
			trieArray := this.children
			For key, subTrie in trieArray
			{
				if (subTrie.isEndOfWord) {
					wordCount++
				}
				childWordCount := subTrie.CalculateWordCount()
				wordCount += childWordCount
			}
		} else {
			subTrie := this.Search(key)
			if (subTrie) {
				wordsArray := subTrie.CalculateWordCount()
			}
		}
		return wordCount
	}

	GetWordsArray(key := "") {
		wordsArray := False
		if (key == "" || key == this.node) {
			wordsArray := Object()
			trieArray := this.children
			; Proceed only if node value is contained within key
			For keyI, subTrie in trieArray
			{
				if (subTrie.isEndOfWord) {
					wordsArray.Push(subTrie.node)
				}
				childWordsArray := subTrie.GetWordsArray()
				For keyJ, value in childWordsArray
				{
					wordsArray.Push(value)				
				}
			}
		} else {
			subTrie := this.Search(key)
			if (subTrie) {
				wordsArray := subTrie.GetWordsArray()
			}
		}
		return wordsArray
	}

	GetPipedWordsList(key := "") {
		wordsList := ""
		if (key == "" || key == this.node) {
			trieArray := this.children
			For keyI, subTrie in trieArray
			{
				if (subTrie.isEndOfWord) {
					wordsList .= "|" . subTrie.node
				}
				childWordsList := subTrie.GetPipedWordsList()
				wordsList .= childWordsList
			}
		} else {
			subTrie := this.Search(key)
			if (subTrie) {
				wordsList .= subTrie.GetPipedWordsList()
			}
		}
		return wordsList
	}

	children[]
	{
		get {
			return this._children
		}
		set {
			return this._children := value
		}
	}

	node[]
	{
		get {
			return this._node
		}
		set {
			return this._node := value
		}
	}

	isEndOfWord[]
	{
		get {
			return this._isEndOfWord
		}
		set {
			return value == True ? this._isEndOfWord := value : this._isEndOfWord := False
		}
	}
}