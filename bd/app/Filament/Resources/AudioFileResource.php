<?php

namespace App\Filament\Resources;

use App\Filament\Resources\AudioFileResource\Pages;
use App\Filament\Resources\AudioFileResource\RelationManagers;
use App\Models\AudioFile;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class AudioFileResource extends Resource
{
    protected static ?string $model = AudioFile::class;

    protected static ?string $navigationIcon = 'heroicon-o-musical-note';

    protected static ?string $navigationGroup = 'Content Management';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Select::make('plant_id')
                    ->relationship('plant', 'scientific_name')
                    ->searchable()
                    ->preload()
                    ->required()
                    ->label('Plant'),
                Forms\Components\Select::make('language_id')
                    ->relationship('language', 'name')
                    ->searchable()
                    ->preload()
                    ->required()
                    ->label('Language'),
                Forms\Components\FileUpload::make('audio_url')
                    ->directory('audio')
                    ->acceptedFileTypes(['audio/mpeg', 'audio/wav'])
                    ->maxSize(5120) // 5MB
                    ->required()
                    ->label('Audio File')
                    ->helperText('Upload an audio file that pronounces the plant name in the selected language. Max size: 5MB')
                    ->downloadable()
                    ->previewable()
                    ->openable(),
                Forms\Components\TextInput::make('description')
                    ->maxLength(255)
                    ->nullable()
                    ->helperText('Optional: Add a description of the audio file (e.g., "Male voice", "Female voice", "Slow pronunciation")'),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('plant.scientific_name')
                    ->searchable()
                    ->sortable()
                    ->label('Plant'),
                Tables\Columns\TextColumn::make('language.name')
                    ->sortable()
                    ->label('Language'),
                Tables\Columns\TextColumn::make('description')
                    ->searchable()
                    ->limit(30)
                    ->toggleable(),
                Tables\Columns\TextColumn::make('audio_url')
                    ->searchable()
                    ->label('Audio File')
                    ->formatStateUsing(fn (string $state): string => basename($state)),
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
                Tables\Filters\SelectFilter::make('language_id')
                    ->relationship('language', 'name'),
                Tables\Filters\SelectFilter::make('plant')
                    ->relationship('plant', 'scientific_name'),
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
            'index' => Pages\ListAudioFiles::route('/'),
            'create' => Pages\CreateAudioFile::route('/create'),
            'edit' => Pages\EditAudioFile::route('/{record}/edit'),
        ];
    }
}
