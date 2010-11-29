// Copyright 2010 Brightec Ltd

#import "TableDataSource.h"
#import "JsonModel.h"
#import "Table.h"
#import "Section.h"
#import "Row.h"

#import "AlphaTextTableCell.h"
#import "AlphaCaptionTableCell.h"
#import "ProductInformationTableItem.h"
#import "ProductDetailCell.h"
#import "AlphaImageTableCell.h"


@implementation TableDataSource


-(id)initWithJsonModel:(JsonModel *)model {
	if (self = [self init]) {
		self.model = model;
	}
	return self;
}


-(void)dealloc {
	self.model = nil;
	[super dealloc];
}


-(void)tableViewDidLoadModel:(UITableView *)tableView {
	Table *t = (Table *) ((JsonModel *)self.model).parsedObject;
	
	NSMutableArray *sections = [NSMutableArray arrayWithCapacity:[t numberOfSections]];
	NSMutableArray *items = [NSMutableArray arrayWithCapacity:[t numberOfSections]];
	
	for (int x=0; x<[t numberOfSections]; x++) {
		Section *s = [t sectionAtIndex:x];
		[sections addObject:(s.title ? s.title : @"")];
		
		NSMutableArray *rows = [NSMutableArray arrayWithCapacity:[s numberOfRows]];
		for (int y=0; y<[s numberOfRows]; y++) {
			id<Row> r = [s rowAtIndex:y];
			
			if ([r isKindOfClass:[TTTableItem class]]) {
				NSLog(@"row %@ is a TTTableItem, using it directly", [r class]);
				[rows addObject:(TTTableItem *)r];
			} else {
				NSLog(@"row %@ is not a TTTableItem, making one up", [r class]);
				[rows addObject:[TTTableTextItem itemWithText:r.title]];
			}
		}
		
		[items addObject:rows];
	}
	
	self.sections = sections;
	self.items = items;
}


// TODO: this class shouldn't know about specific items or cell views

-(Class)tableView:(UITableView *)tableView cellClassForObject:(id)object {
	if ([object isKindOfClass:[ProductInformationTableItem class]]) {
		return [ProductDetailCell class];
	} else if ([object isKindOfClass:[TTTableCaptionItem class]] && tableView.style == UITableViewStyleGrouped) {
		return [AlphaCaptionTableCell class];
	} else if ([object isKindOfClass:[TTTableImageItem class]] && tableView.style == UITableViewStylePlain) {
		return [AlphaImageTableCell class];
	} else if ([object isKindOfClass:[TTTableTextItem class]] && tableView.style == UITableViewStylePlain) {
		return [AlphaTextTableCell class];
	} else {
		return [super tableView:tableView cellClassForObject:object];
	}
}


@end
