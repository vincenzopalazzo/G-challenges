package kik2021

import (
	"fmt"
	"math"

	"github.com/vincenzopalazzo/G-challenges/Gkikstart/utils"
)

func SolveLShapedPlots(filePath *string) {
	inputs := readInput(filePath)
	for test, grid := range inputs {
		items := LShapedPlots(grid)
		printResult(test, items)
	}
}

type Grid struct {
	grid    [][]int64
	rowSize int64
	colSize int64
}

type Segment struct {
	vertical   bool
	fixedIndex int64
	start      int64
	end        int64
	lastUpdate int64
}

func (instance *Segment) isValid() bool {
	return math.Abs(float64(instance.end-instance.start)) >= 2
}

func (instance *Segment) cordinate(reverse bool) string {
	cordinate := instance.start
	if reverse {
		cordinate = instance.end
	}
	if instance.vertical {
		return fmt.Sprintf("%d:%d", instance.fixedIndex, cordinate)
	}
	return fmt.Sprintf("%d:%d", cordinate, instance.fixedIndex)
}

func (instance *Segment) advance(pos int64) bool {
	if instance.start == -1 {
		instance.start = pos
		instance.lastUpdate = pos
		return true
	} else {
		if instance.end == -1 {
			instance.end = pos
			instance.lastUpdate = pos
			return true
		}
		if math.Abs(float64(pos-instance.lastUpdate)) < 2 {
			instance.end = pos
			instance.lastUpdate = pos
			return true
		}
	}
	return false
}

// Main function to solve the problem
func LShapedPlots(grid *Grid) int {
	orizontalMap := make(map[string]*Segment)
	verticalMap := make(map[string]*Segment)

	orizontalSegments := findSegmentFromLeftToRight(grid, orizontalMap)
	verticalSegments := findSegmentFromTopToBottom(grid, verticalMap)
	counter := 0
	for _, segment := range orizontalSegments {
		if isGood(verticalMap, segment) {
			counter++
		}
	}

	for _, segment := range verticalSegments {
		if isGood(orizontalMap, segment) {
			counter++
		}
	}
	return counter
}

func isGood(storage map[string]*Segment, segment *Segment) bool {
	cordinate := segment.cordinate(false)
	_, found := storage[cordinate]
	if !found {
		cordinate = segment.cordinate(true)
		_, found = storage[cordinate]
		return found
	} else {
		return true
	}

	return false
}

// Iterate from left to right and feel the map
func findSegmentFromLeftToRight(grid *Grid, mapToFill map[string]*Segment) []*Segment {
	collection := make([]*Segment, 0)
	for row := int64(0); row < grid.rowSize; row++ {
		segment := &Segment{
			vertical:   false,
			fixedIndex: row,
			start:      -1,
			end:        -1,
			lastUpdate: -1,
		}
		for col := int64(0); col < grid.colSize; col++ {
			if grid.grid[row][col] == 1 {
				if !segment.advance(col) {
					break
				}
			}
		}
		if segment.isValid() {
			cordinate := segment.cordinate(false)
			mapToFill[cordinate] = segment
			collection = append(collection, segment)
		}
	}
	return collection
}

// Iterate from tom to bottom and feel the map with the segments
func findSegmentFromTopToBottom(grid *Grid, mapToFill map[string]*Segment) []*Segment {
	collection := make([]*Segment, 0)
	for col := int64(0); col < grid.colSize; col++ {
		segment := &Segment{
			vertical:   true,
			fixedIndex: col,
			start:      -1,
			end:        -1,
			lastUpdate: -1,
		}
		for row := int64(0); row < grid.rowSize; row++ {
			if grid.grid[row][col] == 1 {
				if !segment.advance(row) {
					continue
				}
			}
		}
		if segment.isValid() {
			collection = append(collection, segment)
			cordinate := segment.cordinate(false)
			mapToFill[cordinate] = segment
		}
	}
	return collection
}

// Print the result of the problem
func printResult(test int, result int) {
	fmt.Printf("Case #%d: %d\n", test, result)
}

// Read the input and return a touple of all the test
func readInput(filePath *string) map[int]*Grid {
	reader := utils.NewInputReader(filePath)

	tests := reader.ReadInt64()
	result := make(map[int]*Grid)
	for test := int64(1); test <= tests; test++ {
		dim := reader.ReadConsecutiveInt64(2)
		rowSize := dim[0]
		colSize := dim[1]

		grid := make([][]int64, rowSize)

		for row := int64(0); row < rowSize; row++ {
			colums := reader.ReadConsecutiveInt64(colSize)
			grid[row] = colums
		}

		result[int(test)] = &Grid{
			grid:    grid,
			rowSize: rowSize,
			colSize: colSize,
		}
	}
	return result
}
