/*****************************************************************************
 * VLCPlaylistItem.m: MacOS X interface module
 *****************************************************************************
 * Copyright (C) 2019 VLC authors and VideoLAN
 *
 * Authors: Felix Paul Kühne <fkuehne # videolan -dot- org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston MA 02110-1301, USA.
 *****************************************************************************/

#import "VLCPlaylistItem.h"
#import "NSString+Helpers.h"
#import <vlc_input.h>

@implementation VLCPlaylistItem

- (instancetype)initWithPlaylistItem:(vlc_playlist_item_t *)p_item
{
    self = [super init];
    if (self) {
        input_item_t *p_media = vlc_playlist_item_GetMedia(p_item);
        vlc_mutex_lock(&p_media->lock);
        _title = toNSStr(p_media->psz_name);
        _duration = p_media->i_duration;

        if (p_media->p_meta) {
            _artistName = toNSStr(vlc_meta_Get(p_media->p_meta, vlc_meta_Artist));
            _albumName = toNSStr(vlc_meta_Get(p_media->p_meta, vlc_meta_Album));
            _artworkURLString = toNSStr(vlc_meta_Get(p_media->p_meta, vlc_meta_ArtworkURL));
        }
        vlc_mutex_unlock(&p_media->lock);
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"item %p, title: %@", &_inputItem, _title];
}

@end