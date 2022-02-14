package kik2021

import (
	"fmt"
	"math"

	"github.com/vincenzopalazzo/G-challenges/Gkikstart/utils"
)

func SolveLShapedPlots(filePath *string) {
	inputs := readInput(filePath)
	for test := 1; test <= len(inputs); test++ {
		grid := inputs[test]
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
}

func (instance *Segment) isValid() bool {
	if instance.start == -1 || instance.end == -1 {
		return false
	}
	return math.Abs(float64(instance.end-instance.start)) >= 2
}

func (instance *Segment) length() int64 {
	return int64(math.Abs(float64(instance.end - instance.start)))
}

func (instance *Segment) coordinate(reverse bool, override int64) string {
	coordinate := instance.start
	if reverse {
		coordinate = instance.end
	}
	if override >= 0 {
		coordinate = override
	}
	if instance.vertical {
		return fmt.Sprintf("%d:%d", coordinate, instance.fixedIndex)
	}
	return fmt.Sprintf("%d:%d", instance.fixedIndex, coordinate)
}

func (instance *Segment) advance(pos int64) bool {
	if instance.start == -1 {
		instance.start = pos
		return true
	} else {
		if instance.end == -1 || math.Abs(float64(pos-instance.end)) == 1 {
			instance.end = pos
			return true
		}
	}
	return false
}

// LShapedPlots Main function to solve the problem
func LShapedPlots(grid *Grid) int {
	horizontalMap := make(map[string]*Segment)
	verticalMap := make(map[string]*Segment)

	horizontalSegments := findSegmentFromLeftToRight(grid, horizontalMap)
	verticalSegments := findSegmentFromTopToBottom(grid, verticalMap)
	counter := 0
	for _, segment := range horizontalSegments {
		if isGood(verticalMap, segment) {
			counter++
		}
	}

	for _, segment := range verticalSegments {
		if isGood(horizontalMap, segment) {
			counter++
		}
	}
	return counter
}

func isGood(storage map[string]*Segment, segment *Segment) bool {
	coordinate := segment.coordinate(false, -1)
	seg, found := storage[coordinate]
	if !found {
		coordinate = segment.coordinate(true, -1)
		seg, found = storage[coordinate]
		if !found {
			return false
		}
	}
	// it is valid only if the shorter segment it
	// al least half of the biggest
	lengthOne := seg.length()
	lengthTwo := segment.length()
	if lengthOne > lengthTwo {
		return lengthTwo*2 <= lengthOne
	}
	return lengthTwo >= lengthOne*2
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
		}
		for col := int64(0); col < grid.colSize; col++ {
			if grid.grid[row][col] == 1 {
				if !segment.advance(col) {
					break
				}
				if segment.isValid() {
					coordinate := segment.coordinate(false, col)
					mapToFill[coordinate] = segment
					collection = append(collection, segment)
				}
			}
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
		}
		for row := int64(0); row < grid.rowSize; row++ {
			if grid.grid[row][col] == 1 {
				if !segment.advance(row) {
					break
				}
			}
			if segment.isValid() {
				coordinate := segment.coordinate(false, row)
				mapToFill[coordinate] = segment
				collection = append(collection, segment)
			}
		}
	}
	return collection
}

// Print the result of the problem
func printResult(test int, result int) {
	fmt.Printf("Case #%d: %d\n", test, result)
}

// Read the input and return a tuple of all the test
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
