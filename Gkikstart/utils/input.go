package utils

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

type InputReader struct {
	scanner *bufio.Scanner
	file    *os.File
}

func NewInputReader(pathFile *string) *InputReader {
	input := &InputReader{}
	if pathFile == nil {
		return input
	}

	file, err := os.Open(*pathFile)

	if err != nil {
		log.Fatal(err)
	}

	input.file = file
	input.scanner = bufio.NewScanner(file)
	return input
}

func (instance *InputReader) Close() {
	if instance.file != nil {
		defer instance.file.Close()
	}
}

func (instance *InputReader) ReadInt64() int64 {
	if instance.scanner == nil {
		var value int64
		fmt.Scanf("%d", &value)
		return value
	}
	if instance.scanner.Scan() {
		line := instance.scanner.Text()
		tokens := strings.Split(line, " ")
		value, err := strconv.ParseInt(tokens[0], 10, 64)
		if err != nil {
			panic(err)
		}
		return value
	}

	panic(fmt.Errorf("No return value found, the is some error"))
}

func (instance *InputReader) ReadConsecutiveInt64(repetition int64) []int64 {
	result := make([]int64, 0)
	if instance.scanner == nil {
		for i := int64(0); i < repetition; i++ {
			var elem int64
			fmt.Scanf("%s", &elem)
			result = append(result, elem)
		}
	} else {
		if instance.scanner.Scan() {
			line := instance.scanner.Text()
			tokens := strings.Split(line, " ")
			for i := int64(0); i < repetition; i++ {
				value, err := strconv.ParseInt(tokens[i], 10, 64)
				if err != nil {
					panic(err)
				}
				result = append(result, value)
			}
		}

	}
	return result
}
