package kik2021

import (
	"fmt"

	"github.com/vincenzopalazzo/G-challenges/Gkikstart/utils"
)

func SolveLShapedPlots(filePath *string) {
	inputs := readInput(filePath)
	for test, grid := range inputs {
		items := LShapedPlots(grid)
		printResult(test, items)
	}
}

type Segment struct {
	vertical bool
	start    int
	end      int
}

func (instance *Segment) IsGood(segment *Segment) bool {
	if instance.start == segment.start {
		return true
	}

	if instance.end == segment.start {
		return true
	}

	if instance.start == segment.end {
		return true
	}

	if instance.end == segment.end {
		return true
	}
	return false
}

func LShapedPlots(grid [][]int64) int {
	//segments := make([]*Segment, 0)
	//TODO: Iterate over the grid and fill segments
	return 0
}

func printResult(test int, result int) {
	fmt.Printf("Case #%d: %d\n", test, result)
}

// Read the input and return a touple of all the test
func readInput(filePath *string) map[int][][]int64 {
	reader := utils.NewInputReader(filePath)

	tests := reader.ReadInt64()
	result := make(map[int][][]int64)
	for test := int64(1); test <= tests; test++ {
		dim := reader.ReadConsecutiveInt64(2)
		rowSize := dim[0]
		colSize := dim[1]

		grid := make([][]int64, rowSize)

		for row := int64(0); row < rowSize; row++ {
			colums := reader.ReadConsecutiveInt64(colSize)
			grid[row] = colums
		}

		result[int(test)] = grid
	}
	return result
}
