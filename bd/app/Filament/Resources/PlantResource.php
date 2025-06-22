<?php

namespace App\Filament\Resources;

use App\Filament\Resources\PlantResource\Pages;
use App\Filament\Resources\PlantResource\RelationManagers;
use App\Models\Plant;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class PlantResource extends Resource
{
    protected static ?string $model = Plant::class;

    protected static ?string $navigationIcon = 'heroicon-o-leaf';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\TextInput::make('slug')
                    ->required()
                    ->unique(ignoreRecord: true)
                    ->maxLength(255),
                Forms\Components\TextInput::make('scientific_name')
                    ->required()
                    ->maxLength(255),
                Forms\Components\TextInput::make('family')
                    ->maxLength(255),
                Forms\Components\TextInput::make('genus')
                    ->maxLength(255),
                Forms\Components\TextInput::make('species')
                    ->maxLength(255),
                Forms\Components\TextInput::make('origin')
                    ->maxLength(255),
                Forms\Components\FileUpload::make('image_urls')
                    ->multiple()
                    ->image()
                    ->directory('plants')
                    ->required(),
                Forms\Components\Textarea::make('habitat')
                    ->maxLength(65535)
                    ->columnSpanFull(),
                Forms\Components\TagsInput::make('uses')
                    ->placeholder('Add uses...'),
                Forms\Components\Select::make('toxicity_level')
                    ->options([
                        'Non-toxic' => 'Non-toxic',
                        'Low' => 'Low',
                        'Moderate' => 'Moderate',
                        'High' => 'High',
                    ]),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('scientific_name')
                    ->searchable(),
                Tables\Columns\TextColumn::make('family')
                    ->searchable(),
                Tables\Columns\TextColumn::make('genus')
                    ->searchable(),
                Tables\Columns\TextColumn::make('species')
                    ->searchable(),
                Tables\Columns\TextColumn::make('toxicity_level')
                    ->searchable(),
                Tables\Columns\TextColumn::make('created_at')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
                Tables\Columns\TextColumn::make('updated_at')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                //
            ])
            ->actions([
                Tables\Actions\EditAction::make(),
                Tables\Actions\DeleteAction::make(),
            ])
            ->bulkActions([
                Tables\Actions\BulkActionGroup::make([
                    Tables\Actions\DeleteBulkAction::make(),
                ]),
            ]);
    }

    public static function getRelations(): array
    {
        return [
            //
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListPlants::route('/'),
            'create' => Pages\CreatePlant::route('/create'),
            'edit' => Pages\EditPlant::route('/{record}/edit'),
        ];
    }
}
